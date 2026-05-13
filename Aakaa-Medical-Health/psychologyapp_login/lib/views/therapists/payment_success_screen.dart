import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/therapist_model.dart';
import '../../models/consultation_type.dart';
import '../../models/session_model.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
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
      body: SafeArea(
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
                  decoration: const BoxDecoration(
                    color: Color(0xFF065643),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Payment Successful",
                style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF065643)),
              ),
              const SizedBox(height: 12),
              Text(
                "Your session with ${widget.therapist.name} is confirmed and ready to start.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(color: Colors.grey[600], height: 1.5),
              ),
              const SizedBox(height: 48),
              _buildReceiptCard(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final session = TherapySession(
                      id: "SESS_${DateTime.now().millisecondsSinceEpoch}",
                      therapistName: widget.therapist.name,
                      therapistInitials: widget.therapist.name.split(' ').last[0],
                      startTime: DateTime.now(),
                      endTime: DateTime.now().add(const Duration(minutes: 50)),
                      consultationType: widget.consultationType,
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SessionHub(session: session)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF065643),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text("Start Session Now", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Payment Success
                  Navigator.of(context).pop(); // Payment
                  Navigator.of(context).pop(); // Booking
                  Navigator.of(context).pop(); // Therapist Detail
                },
                child: Text("Back to Home", style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF065643).withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: Column(
        children: [
          _receiptRow("Transaction ID", "#AAK-${DateTime.now().millisecond}992"),
          const Divider(height: 32),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 14)),
          Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
        ],
      ),
    );
  }
}
