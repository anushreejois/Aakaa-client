import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_controller.dart';
import 'signup_loginfunctionality.dart';

class ActivityController {
  static int sessionCount = 0;
  static int moodLogCount = 0;
  static double growthPercentage = 0.50;
  static String averageMoodLabel = "Okay";
  static int mindfulMinutes = 0;

  static const String joinDate = "May 10";
  static const String firstSessionDate = "May 12";
  static int currentStreakDays = 0;

  static String get currentStreak => "$currentStreakDays Day Streak";

  // Reactive Mood History (0 to 4 scale)
  static final ValueNotifier<List<Map<String, dynamic>>> moodHistoryNotifier =
      ValueNotifier([
    {"day": "Mon", "value": 3, "mood": "Good", "time": "Mon, 10:30 AM"},
    {"day": "Tue", "value": 2, "mood": "Okay", "time": "Tue, 11:15 AM"},
    {"day": "Wed", "value": 4, "mood": "Great", "time": "Wed, 09:00 AM"},
    {"day": "Thu", "value": 3, "mood": "Good", "time": "Thu, 02:45 PM"},
    {"day": "Fri", "value": 4, "mood": "Great", "time": "Fri, 08:30 AM"},
    {"day": "Sat", "value": 4, "mood": "Great", "time": "Sat, 10:00 AM"},
    {"day": "Sun", "value": 3, "mood": "Good", "time": "Sun, 09:45 AM"},
  ]);

  static List<Map<String, dynamic>> get moodHistory =>
      moodHistoryNotifier.value;

  // Fetch live aggregated summary from MongoDB via Node.js
  static Future<void> fetchActivitySummary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null || token.isEmpty) return;

      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/users/activity-summary");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        sessionCount = data["sessionCount"] ?? 0;
        moodLogCount = data["moodLogCount"] ?? 0;
        currentStreakDays = data["streakCount"] ?? 0;
        growthPercentage = (data["growthPercentage"] as num?)?.toDouble() ?? 0.50;
        averageMoodLabel = data["averageMood"] ?? "Okay";
        mindfulMinutes = data["mindfulMinutes"] ?? 0;

        if (data["journalEntries"] != null) {
          final List<dynamic> entries = data["journalEntries"];
          final formattedJournals = entries.map<Map<String, String>>((e) {
            return {
              "date": e["date"].toString(),
              "content": e["content"].toString()
            };
          }).toList();

          journalEntriesNotifier.value = formattedJournals;
        }

        if (data["moodHistory"] != null) {
          final List<dynamic> historyList = data["moodHistory"];
          final formattedHistory = historyList.map<Map<String, dynamic>>((m) {
            return {
              "day": m["day"].toString(),
              "value": m["value"] as int,
              "mood": m["mood"].toString(),
              "time": m["time"].toString()
            };
          }).toList();

          moodHistoryNotifier.value = formattedHistory;
        } else {
          // Trigger UI updates on fallback
          moodHistoryNotifier.value = List.from(moodHistoryNotifier.value);
        }
      }
    } catch (e) {
      debugPrint("Error fetching activity summary: $e");
    }
  }

  // Increment live mindfulness minutes in MongoDB
  static Future<void> incrementMindfulMinutes(int minutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null || token.isEmpty) return;

      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/users/mindfulness");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "minutes": minutes
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        mindfulMinutes = data["mindfulMinutes"] ?? (mindfulMinutes + minutes);
      }
      
      // Sync fresh data
      await fetchActivitySummary();
    } catch (e) {
      debugPrint("Error incrementing mindful minutes: $e");
    }
  }

  // Log new mood to database
  static Future<String> logMood(int value, String moodLabel) async {
    String statusMessage = "Mood logged successfully.";
    try {
      // Optimistic UI updates
      final updatedList =
          List<Map<String, dynamic>>.from(moodHistoryNotifier.value);

      updatedList.removeLast();
      updatedList.add({
        "day": "Sun",
        "value": value,
        "mood": moodLabel,
        "time": "Today, ${_formattedTimeNow()}",
      });

      moodHistoryNotifier.value = updatedList;

      // Backend sync
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null || token.isEmpty) return statusMessage;

      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/users/mood-log");
      // Map 0-4 slider index to 1-5 database scale
      final mappedScore = value + 1;

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "moodScore": mappedScore
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        statusMessage = data["message"] ?? "Mood logged successfully.";
        
        NotificationController.addNotification(
          title: "Mindfulness Streak",
          body: "Amazing consistency! You have logged your mood successfully.",
          iconType: "mood",
        );
      }

      // Fresh fetch to sync all counts and dynamic 7-day chart logs
      await fetchActivitySummary();
    } catch (e) {
      debugPrint("Error syncing mood: $e");
    }
    return statusMessage;
  }

  static String _formattedTimeNow() {
    final now = DateTime.now();
    int hour = now.hour > 12 ? now.hour - 12 : now.hour;
    if (hour == 0) hour = 12;
    String period = now.hour >= 12 ? "PM" : "AM";
    String minute = now.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  // Growth Journey Milestones
  static final List<Map<String, String>> milestones = [
    {"title": "Joined Aakaa", "date": joinDate, "icon": "stars"},
    {"title": "First Session", "date": firstSessionDate, "icon": "verified"},
    {"title": "Deep Focus", "date": "June 05", "icon": "self_improvement"},
    {
      "title": "Mindfulness Master",
      "date": "June 20",
      "icon": "workspace_premium"
    },
  ];

  static String get formattedGrowth => "${(growthPercentage * 100).toInt()}%";

  // Reactive Gratitude Notes
  static final ValueNotifier<List<String>> gratitudeNotesNotifier =
      ValueNotifier([
    "Morning sunlight streaming through my window",
    "A peaceful cup of chamomile tea",
  ]);

  static void addGratitude(String note) {
    final updated = List<String>.from(gratitudeNotesNotifier.value);
    updated.insert(0, note);
    gratitudeNotesNotifier.value = updated;
    currentStreakDays++;
    if (growthPercentage < 0.98) growthPercentage += 0.01;
    
    // Trigger listeners
    moodHistoryNotifier.value = List.from(moodHistoryNotifier.value);

    NotificationController.addNotification(
      title: "Gratitude Released",
      body: "Your gratitude note has been saved to your personal jar.",
      iconType: "journal",
    );
  }

  // Reactive Journal Entries
  static final ValueNotifier<List<Map<String, String>>> journalEntriesNotifier =
      ValueNotifier([
    {
      "date": "Yesterday",
      "content":
          "Felt overwhelming clarity today after completing my meditation session. My mind feels remarkably peaceful.",
    }
  ]);

  static Future<void> addJournalEntry(String content) async {
    try {
      // Optimistic UI updates
      final updated =
          List<Map<String, String>>.from(journalEntriesNotifier.value);
      updated.insert(0, {
        "date": "Today, ${_formattedTimeNow()}",
        "content": content,
      });
      journalEntriesNotifier.value = updated;
      currentStreakDays++;
      if (growthPercentage < 0.98) growthPercentage += 0.02;
      
      // Trigger listeners
      moodHistoryNotifier.value = List.from(moodHistoryNotifier.value);

      NotificationController.addNotification(
        title: "Reflective Moment",
        body: "Your journal reflection has been securely released and preserved.",
        iconType: "journal",
      );

      // Backend sync
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null || token.isEmpty) return;

      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/users/journal");
      await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "content": content
        }),
      );

      // Fresh fetch to sync all counts and dynamic 7-day chart logs
      await fetchActivitySummary();
    } catch (e) {
      debugPrint("Error syncing journal entry: $e");
    }
  }
}
