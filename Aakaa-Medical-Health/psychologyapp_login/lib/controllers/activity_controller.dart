import 'package:flutter/material.dart';
import 'notification_controller.dart';

class ActivityController {
  static int sessionCount = 14;
  static int moodLogCount = 32;
  static double growthPercentage = 0.88;
  
  static const String joinDate = "May 10";
  static const String firstSessionDate = "May 12";
  static int currentStreakDays = 12;

  static String get currentStreak => "$currentStreakDays Day Streak";

  // Reactive Mood History (0 to 4 scale)
  static final ValueNotifier<List<Map<String, dynamic>>> moodHistoryNotifier = ValueNotifier([
    {"day": "Mon", "value": 3, "mood": "Good", "time": "Mon, 10:30 AM"},
    {"day": "Tue", "value": 2, "mood": "Okay", "time": "Tue, 11:15 AM"},
    {"day": "Wed", "value": 4, "mood": "Great", "time": "Wed, 09:00 AM"},
    {"day": "Thu", "value": 3, "mood": "Good", "time": "Thu, 02:45 PM"},
    {"day": "Fri", "value": 4, "mood": "Great", "time": "Fri, 08:30 AM"},
    {"day": "Sat", "value": 4, "mood": "Great", "time": "Sat, 10:00 AM"},
    {"day": "Sun", "value": 3, "mood": "Good", "time": "Sun, 09:45 AM"},
  ]);

  static List<Map<String, dynamic>> get moodHistory => moodHistoryNotifier.value;

  static void logMood(int value, String moodLabel) {
    final updatedList = List<Map<String, dynamic>>.from(moodHistoryNotifier.value);
    
    // Update the most recent day (Sunday) with the new logged mood
    updatedList.removeLast();
    updatedList.add({
      "day": "Sun",
      "value": value,
      "mood": moodLabel,
      "time": "Today, ${_formattedTimeNow()}",
    });

    moodLogCount++;
    currentStreakDays++;
    if (growthPercentage < 0.98) {
      growthPercentage += 0.02;
    }
    moodHistoryNotifier.value = updatedList;

    NotificationController.addNotification(
      title: "Mindfulness Streak",
      body: "Amazing consistency! You are now on a $currentStreakDays day check-in streak.",
      iconType: "mood",
    );
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
    {"title": "Mindfulness Master", "date": "June 20", "icon": "workspace_premium"},
  ];

  static String get formattedGrowth => "${(growthPercentage * 100).toInt()}%";

  // Reactive Gratitude Notes
  static final ValueNotifier<List<String>> gratitudeNotesNotifier = ValueNotifier([
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
  static final ValueNotifier<List<Map<String, String>>> journalEntriesNotifier = ValueNotifier([
    {
      "date": "Yesterday",
      "content": "Felt overwhelming clarity today after completing my meditation session. My mind feels remarkably peaceful.",
    }
  ]);

  static void addJournalEntry(String content) {
    final updated = List<Map<String, String>>.from(journalEntriesNotifier.value);
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
  }
}

