import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/zen_background.dart';

class VideoCallScreen extends StatefulWidget {
  final String therapistName;

  const VideoCallScreen({
    super.key,
    required this.therapistName,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isCameraOn = true;
  int _callDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _callDuration++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
        child: Stack(
          children: [
            // Main Simulated Video Feed
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
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
                    const SizedBox(height: 32),
                    Text(
                      widget.therapistName,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF065643), 
                        fontSize: 32, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Secure video consultation in progress...",
                      style: GoogleFonts.outfit(
                        color: Colors.grey[600], 
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // User Video Feed (Floating Window)
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              right: 24,
              child: Container(
                width: 110,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05), 
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.person_outline_rounded, 
                          color: const Color(0xFF065643).withValues(alpha: 0.2), 
                          size: 48,
                        )
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF065643).withValues(alpha: 0.08), 
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.flip_camera_ios_rounded, color: Color(0xFF065643), size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Header Info
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.fiber_manual_record_rounded, color: Colors.redAccent, size: 12),
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.lock_rounded, color: const Color(0xFF065643).withValues(alpha: 0.4), size: 14),
                      const SizedBox(width: 8),
                      Text(
                        "End-to-End Encrypted",
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF065643).withValues(alpha: 0.5), 
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Controls Area
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 30,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(48),
                  border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildControlButton(
                      _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                      _isMuted,
                      () => setState(() => _isMuted = !_isMuted),
                    ),
                    _buildControlButton(
                      _isCameraOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                      !_isCameraOn,
                      () => setState(() => _isCameraOn = !_isCameraOn),
                    ),
                    const SizedBox(width: 16),
                    _buildEndCallButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF4B4B).withValues(alpha: 0.15) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? const Color(0xFFFF4B4B).withValues(alpha: 0.4) : const Color(0xFF065643).withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: isActive ? [] : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon, 
          color: isActive ? const Color(0xFFFF4B4B) : const Color(0xFF065643), 
          size: 28,
        ),
      ),
    );
  }

  Widget _buildEndCallButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4B4B),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4B4B).withValues(alpha: 0.3), 
                blurRadius: 20, 
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}
