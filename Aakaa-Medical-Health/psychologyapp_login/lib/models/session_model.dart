import '../../models/consultation_type.dart';

class TherapySession {
  final String id;
  final String therapistName;
  final String therapistInitials;
  final DateTime startTime;
  final DateTime endTime;
  final ConsultationType consultationType;
  bool isActive;

  TherapySession({
    required this.id,
    required this.therapistName,
    required this.therapistInitials,
    required this.startTime,
    required this.endTime,
    required this.consultationType,
    this.isActive = true,
  });
}
