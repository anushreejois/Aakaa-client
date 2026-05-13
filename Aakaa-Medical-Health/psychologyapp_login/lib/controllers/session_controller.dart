import '../models/session_model.dart';
import '../models/consultation_type.dart';

class SessionController {
  static final List<TherapySession> upcomingSessions = [
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
  ];

  static final List<TherapySession> pastSessions = [
    TherapySession(
      id: "p1",
      therapistName: "Dr. Emily White",
      therapistInitials: "EW",
      startTime: DateTime.now().subtract(const Duration(days: 10)),
      endTime: DateTime.now().subtract(const Duration(days: 10, minutes: 45)),
      consultationType: ConsultationType.video,
    ),
  ];
}
