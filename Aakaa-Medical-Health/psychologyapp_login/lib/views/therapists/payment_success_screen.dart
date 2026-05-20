import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/therapist_model.dart';
import '../../models/consultation_type.dart';
import '../../models/session_model.dart';
import '../../widgets/zen_background.dart';
import '../../controllers/session_controller.dart';
import 'session_hub.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final Therapist therapist;
  final ConsultationType consultationType;

  const PaymentSuccessScreen({
    super.key,
    required this.therapist,
    required this.consultationType,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  late TherapySession _bookedSession;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();

    String init = "DR";
    final parts = widget.therapist.name.split(' ');
    if (parts.length > 1) {
      init = parts[0][0] + parts[parts.length - 1][0];
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      init = parts[0][0];
    }

    _bookedSession = TherapySession(
      id: "SESS_${DateTime.now().millisecondsSinceEpoch}",
      therapistName: widget.therapist.name,
      therapistInitials: init.toUpperCase(),
      startTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 2, minutes: 50)),
      consultationType: widget.consultationType,
    );
    SessionController.addNewSession(_bookedSession);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF065643),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF065643).withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  "Payment Successful",
                  style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF065643)),
                ),
                const SizedBox(height: 12),
                Text(
                  "Your session with ${widget.therapist.name} is confirmed and ready to start.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.7), height: 1.5, fontSize: 15),
                ),
                const SizedBox(height: 48),
                _buildReceiptCard(),
                const Spacer(),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF065643).withValues(alpha: 0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SessionHub(session: _bookedSession)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    child: Text("Start Session Now", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text("Back to Home", style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.06), 
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _receiptRow("Transaction ID", "#AAK-${DateTime.now().millisecond}992"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: const Color(0xFF065643).withValues(alpha: 0.1)),
          ),
          _receiptRow("Therapist", widget.therapist.name),
          _receiptRow("Type", _getTypeLabel()),
          _receiptRow("Duration", "50 Minutes"),
        ],
      ),
    );
  }

  String _getTypeLabel() {
    switch (widget.consultationType) {
      case ConsultationType.message: return "Messaging";
      case ConsultationType.audio: return "Audio Call";
      case ConsultationType.video: return "Video Call";
    }
  }

  Widget _receiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.6), fontSize: 15, fontWeight: FontWeight.w500)),
          Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF065643))),
        ],
      ),
    );
  }
}
