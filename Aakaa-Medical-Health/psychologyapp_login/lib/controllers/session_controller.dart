import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session_model.dart';
import '../models/consultation_type.dart';
import 'notification_controller.dart';
import 'signup_loginfunctionality.dart';

class SessionController {
  static final ValueNotifier<List<TherapySession>> upcomingSessionsNotifier = ValueNotifier([]);
  static final ValueNotifier<List<TherapySession>> pastSessionsNotifier = ValueNotifier([]);

  static List<TherapySession> get upcomingSessions => upcomingSessionsNotifier.value;
  static List<TherapySession> get pastSessions => pastSessionsNotifier.value;

  // Fetch upcoming and past sessions from the server
  static Future<void> fetchSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null || token.isEmpty) return;

      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/users/sessions");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        final upcomingList = (data["upcoming"] as List).map<TherapySession>((s) {
          ConsultationType type = ConsultationType.video;
          if (s["consultationType"] == "chat" || s["consultationType"] == "message") {
            type = ConsultationType.message;
          } else if (s["consultationType"] == "audio") {
            type = ConsultationType.audio;
          }
          return TherapySession(
            id: s["id"].toString(),
            therapistName: s["therapistName"].toString(),
            therapistInitials: s["therapistInitials"].toString(),
            startTime: DateTime.parse(s["startTime"].toString()).toLocal(),
            endTime: DateTime.parse(s["endTime"].toString()).toLocal(),
            consultationType: type,
          );
        }).toList();

        final pastList = (data["past"] as List).map<TherapySession>((s) {
          ConsultationType type = ConsultationType.video;
          if (s["consultationType"] == "chat" || s["consultationType"] == "message") {
            type = ConsultationType.message;
          } else if (s["consultationType"] == "audio") {
            type = ConsultationType.audio;
          }
          return TherapySession(
            id: s["id"].toString(),
            therapistName: s["therapistName"].toString(),
            therapistInitials: s["therapistInitials"].toString(),
            startTime: DateTime.parse(s["startTime"].toString()).toLocal(),
            endTime: DateTime.parse(s["endTime"].toString()).toLocal(),
            consultationType: type,
          );
        }).toList();

        upcomingSessionsNotifier.value = upcomingList;
        pastSessionsNotifier.value = pastList;
      }
    } catch (e) {
      debugPrint("Error fetching sessions: $e");
    }
  }

  // Create booking
  static Future<void> addNewSession(TherapySession session) async {
    try {
      final updated = List<TherapySession>.from(upcomingSessionsNotifier.value);
      updated.insert(0, session);
      upcomingSessionsNotifier.value = updated;

      NotificationController.addNotification(
        title: "Session Confirmed",
        body: "Your ${session.consultationType.name} consultation with ${session.therapistName} has been booked successfully.",
        iconType: "session",
      );

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null || token.isEmpty) return;

      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/users/book-session");
      String typeStr = "video";
      if (session.consultationType == ConsultationType.message) {
        typeStr = "chat";
      } else if (session.consultationType == ConsultationType.audio) {
        typeStr = "audio";
      }

      // Find standard therapist ID from backend or create mock ID
      await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "therapistId": "66579899fcd34d3d2c88f12a", // standard mock therapist ID
          "appointmentDate": session.startTime.toUtc().toIso8601String(),
          "consultationType": typeStr
        }),
      );
    } catch (e) {
      debugPrint("Error syncing session booking: $e");
    }
  }
}
