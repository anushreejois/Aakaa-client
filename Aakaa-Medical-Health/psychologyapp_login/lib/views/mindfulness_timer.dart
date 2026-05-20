import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../widgets/zen_background.dart';

class MindfulnessTimer extends StatefulWidget {
  const MindfulnessTimer({super.key});

  @override
  State<MindfulnessTimer> createState() => _MindfulnessTimerState();
}

class _MindfulnessTimerState extends State<MindfulnessTimer> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _scaleAnimation;
  
  int _secondsRemaining = 300; // 5 Minutes default
  bool _isStarted = false;
  Timer? _timer;
  String _breathText = "Breathe in...";

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _breathText = "And hold...");
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() => _breathText = "Breathe out...");
              _breathingController.reverse();
            }
          });
        } else if (status == AnimationStatus.dismissed) {
          setState(() => _breathText = "And hold...");
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted && _isStarted) {
              setState(() => _breathText = "Breathe in...");
              _breathingController.forward();
            }
          });
        }
      });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOutSine),
    );
  }

  void _toggleTimer() {
    setState(() {
      _isStarted = !_isStarted;
      if (_isStarted) {
        _breathingController.forward();
        _startCountdown();
      } else {
        _breathingController.stop();
        _timer?.cancel();
      }
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _toggleTimer();
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF7F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: Text("Well Done", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
        content: Text("You've completed your mindfulness session. How do you feel?", style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.8))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Refreshed", style: GoogleFonts.outfit(color: const Color(0xFF0A7D62), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return "$mins:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: Stack(
          children: [
            // Back Button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF065643), size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Breathing Circle
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer Glow
                          Container(
                            width: 200 * _scaleAnimation.value,
                            height: 200 * _scaleAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF065643).withValues(alpha: 0.04),
                            ),
                          ),
                          // Inner Circle
                          Container(
                            width: 150 * _scaleAnimation.value,
                            height: 150 * _scaleAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF065643).withValues(alpha: 0.08),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
                            ),
                            child: Icon(Icons.spa_rounded, color: const Color(0xFF065643).withValues(alpha: 0.3), size: 40),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 60),
                  
                  Text(
                    _breathText,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF065643),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    _formatTime(_secondsRemaining),
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF065643).withValues(alpha: 0.6),
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // Play/Pause Button
                  GestureDetector(
                    onTap: _toggleTimer,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF065643).withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
                      ),
                      child: Icon(
                        _isStarted ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: const Color(0xFF065643),
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
