import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/session_model.dart';
import '../../models/consultation_type.dart';
import '../therapists/chat_screen.dart';
import '../therapists/video_call_screen.dart';
import '../therapists/audio_call_screen.dart';

class SessionHub extends StatefulWidget {
  final TherapySession session;

  const SessionHub({super.key, required this.session});

  @override
  State<SessionHub> createState() => _SessionHubState();
}

class _SessionHubState extends State<SessionHub> {
  late Duration _remainingTime;
  Timer? _timer;
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.session.endTime.difference(DateTime.now());
    if (!_remainingTime.isNegative) {
      _startTimer();
    } else {
      _remainingTime = Duration.zero;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds <= 1) {
        timer.cancel();
        _endSession();
      } else {
        setState(() {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        });
      }
    });
  }

  void _endSession() {
    _timer?.cancel();
    _showFeedbackDialog();
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF065643).withOpacity(0.98),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 24),
                Text(
                  "Session Completed",
                  style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  "How was your experience with Dr. ${widget.session.therapistName.split(' ').last}?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.5), fontSize: 16),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: index < _rating ? Colors.amber : Colors.white.withOpacity(0.2),
                        size: 40,
                      ),
                      onPressed: () => setDialogState(() => _rating = index + 1.0),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: TextField(
                    controller: _feedbackController,
                    maxLines: 3,
                    style: GoogleFonts.outfit(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Any thoughts you'd like to share?",
                      hintStyle: GoogleFonts.outfit(color: Colors.white.withOpacity(0.2)),
                      contentPadding: const EdgeInsets.all(20),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Exit Hub
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF065643),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text("Done", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF065643), Color(0xFF0A7D62), Color(0xFF065643)],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.shield_rounded, color: Colors.greenAccent, size: 14),
                            const SizedBox(width: 8),
                            Text(
                              "Secure Session",
                              style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Timer Circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: CircularProgressIndicator(
                        value: _remainingTime.inSeconds / widget.session.endTime.difference(widget.session.startTime).inSeconds,
                        strokeWidth: 4,
                        color: Colors.white,
                        backgroundColor: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Time Remaining",
                          style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.5), fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _formatTime(_remainingTime),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

            const Spacer(),

            // Therapist Brief Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), 
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    alignment: Alignment.center,
                    child: Text(widget.session.therapistInitials, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.session.therapistName,
                          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          "Clinical Specialist",
                          style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.5), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 24),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Control Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildActionButton(
                    Icons.chat_bubble_rounded, 
                    "Chat", 
                    widget.session.consultationType == ConsultationType.message,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(therapistName: widget.session.therapistName))),
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    Icons.call_rounded, 
                    "Audio", 
                    widget.session.consultationType == ConsultationType.audio,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => AudioCallScreen(therapistName: widget.session.therapistName))),
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    Icons.videocam_rounded, 
                    "Video", 
                    widget.session.consultationType == ConsultationType.video,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => VideoCallScreen(therapistName: widget.session.therapistName))),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    ],
  ),
);
  }

  Widget _buildActionButton(IconData icon, String label, bool isEnabled, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: isEnabled ? Colors.white : Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isEnabled ? Colors.white : Colors.white.withOpacity(0.05),
              width: 1,
            ),
            boxShadow: isEnabled ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ] : [],
          ),
          child: Column(
            children: [
              Icon(
                icon, 
                color: isEnabled ? const Color(0xFF065643) : Colors.white.withOpacity(0.1), 
                size: 30,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: isEnabled ? const Color(0xFF065643) : Colors.white.withOpacity(0.1),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
