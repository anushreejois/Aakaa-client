import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../models/consultation_type.dart';
import 'notification_controller.dart';

class SessionController {
  static final ValueNotifier<List<TherapySession>> upcomingSessionsNotifier = ValueNotifier([
    TherapySession(
      id: "s1",
      therapistName: "Dr. Sarah Johnson",
      therapistInitials: "SJ",
      startTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
      endTime: DateTime.now().add(const Duration(days: 2, hours: 3, minutes: 45)),
      consultationType: ConsultationType.video,
    ),
    TherapySession(
      id: "s2",
      therapistName: "Dr. Michael Chen",
      therapistInitials: "MC",
      startTime: DateTime.now().add(const Duration(days: 5, hours: 1)),
      endTime: DateTime.now().add(const Duration(days: 5, hours: 1, minutes: 30)),
      consultationType: ConsultationType.message,
    ),
  ]);

  static final ValueNotifier<List<TherapySession>> pastSessionsNotifier = ValueNotifier([
    TherapySession(
      id: "p1",
      therapistName: "Dr. Emily White",
      therapistInitials: "EW",
      startTime: DateTime.now().subtract(const Duration(days: 10)),
      endTime: DateTime.now().subtract(const Duration(days: 10, minutes: 45)),
      consultationType: ConsultationType.video,
    ),
  ]);

  static List<TherapySession> get upcomingSessions => upcomingSessionsNotifier.value;
  static List<TherapySession> get pastSessions => pastSessionsNotifier.value;

  static void addNewSession(TherapySession session) {
    final updated = List<TherapySession>.from(upcomingSessionsNotifier.value);
    updated.insert(0, session);
    upcomingSessionsNotifier.value = updated;

    NotificationController.addNotification(
      title: "Session Confirmed",
      body: "Your ${session.consultationType.name} consultation with ${session.therapistName} has been booked successfully.",
      iconType: "session",
    );
  }
}

