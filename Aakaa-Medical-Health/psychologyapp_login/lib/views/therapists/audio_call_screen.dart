import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/zen_background.dart';

class AudioCallScreen extends StatefulWidget {
  final String therapistName;

  const AudioCallScreen({
    super.key,
    required this.therapistName,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> with SingleTickerProviderStateMixin {
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  int _callDuration = 0;
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _callDuration++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Therapist Info & Pulsing Avatar
              Center(
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.1).animate(_pulseController),
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08), width: 12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF065643).withValues(alpha: 0.05),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.15), width: 2),
                            image: const DecorationImage(
                              image: NetworkImage("https://images.unsplash.com/photo-1559839734-2b71f153678e?w=400&h=400&fit=crop"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      widget.therapistName,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF065643), 
                        fontSize: 32, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.fiber_manual_record_rounded, color: Color(0xFF0A7D62), size: 12),
                          const SizedBox(width: 10),
                          Text(
                            _formatDuration(_callDuration),
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF065643), 
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Security Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_rounded, color: const Color(0xFF065643).withValues(alpha: 0.4), size: 14),
                  const SizedBox(width: 8),
                  Text(
                    "End-to-End Encrypted Audio",
                    style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.5), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Controls
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 40, 
                  bottom: MediaQuery.of(context).padding.bottom + 40, 
                  left: 32, 
                  right: 32
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
                  border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 30,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                      _isMuted ? "Unmute" : "Mute",
                      _isMuted,
                      () => setState(() => _isMuted = !_isMuted),
                    ),
                    _buildEndCallButton(),
                    _buildControlButton(
                      _isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                      "Speaker",
                      !_isSpeakerOn,
                      () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF065643) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF065643).withValues(alpha: isActive ? 1.0 : 0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon, 
              color: isActive ? Colors.white : const Color(0xFF065643), 
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label, 
            style: GoogleFonts.outfit(
              color: const Color(0xFF065643).withValues(alpha: 0.7), 
              fontSize: 14,
              fontWeight: FontWeight.w600,
            )
          ),
        ],
      ),
    );
  }

  Widget _buildEndCallButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4B4B),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4B4B).withValues(alpha: 0.3), 
                  blurRadius: 25, 
                  offset: const Offset(0, 10)
                )
              ],
            ),
            child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 12),
          Text(
            "End Call", 
            style: GoogleFonts.outfit(
              color: const Color(0xFFFF4B4B), 
              fontSize: 14,
              fontWeight: FontWeight.bold,
            )
          ),
        ],
      ),
    );
  }
}
