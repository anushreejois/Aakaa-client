import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color(0xFF065643),
      body: Stack(
        children: [
          // Main Video Feed (Placeholder for Therapist)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF065643), Color(0xFF1A1A1A)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 8),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
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
                        color: Colors.white, 
                        fontSize: 28, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Consultation in progress...",
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.5), 
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
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
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4), 
                    blurRadius: 25,
                    spreadRadius: 5,
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
                        color: Colors.white.withOpacity(0.1), 
                        size: 48,
                      )
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5), 
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white, size: 14),
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
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.fiber_manual_record_rounded, color: Colors.redAccent, size: 12),
                      const SizedBox(width: 10),
                      Text(
                        _formatDuration(_callDuration),
                        style: GoogleFonts.outfit(
                          color: Colors.white, 
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
                    Icon(Icons.lock_rounded, color: Colors.white.withOpacity(0.3), size: 14),
                    const SizedBox(width: 8),
                    Text(
                      "End-to-End Encrypted",
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.3), 
                        fontSize: 12,
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
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(48),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
    );
  }

  Widget _buildControlButton(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF4B4B).withOpacity(0.2) : Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? const Color(0xFFFF4B4B).withOpacity(0.5) : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Icon(
          icon, 
          color: isActive ? const Color(0xFFFF4B4B) : Colors.white, 
          size: 28,
        ),
      ),
    );
  }

  Widget _buildEndCallButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFF4B4B),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF4B4B).withOpacity(0.4), 
              blurRadius: 25, 
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 32),
      ),
    );
  }
}
