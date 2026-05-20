import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';

class DailyAffirmation extends StatefulWidget {
  const DailyAffirmation({super.key});

  @override
  State<DailyAffirmation> createState() => _DailyAffirmationState();
}

class _DailyAffirmationState extends State<DailyAffirmation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<String> _affirmations = [
    "I am worthy of peace and happiness.",
    "My potential is limitless.",
    "I choose to be kind to myself today.",
    "I am resilient, strong, and brave.",
    "Every breath I take fills me with calm.",
    "I trust the journey of my life.",
    "I am in charge of how I feel and today I choose happiness.",
    "My challenges help me grow.",
    "I am enough, just as I am.",
    "I radiate confidence, self-respect, and inner harmony."
  ];

  late String _currentAffirmation;

  @override
  void initState() {
    super.initState();
    _currentAffirmation = _affirmations[Random().nextInt(_affirmations.length)];
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextAffirmation() {
    _controller.reverse().then((_) {
      setState(() {
        _currentAffirmation = _affirmations[Random().nextInt(_affirmations.length)];
      });
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZenBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF065643), size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Daily Affirmation",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF065643),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance for close button
                  ],
                ),
              ),

              const Spacer(),

              // Affirmation Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Icon(Icons.format_quote_rounded, color: const Color(0xFF065643).withValues(alpha: 0.2), size: 60),
                      const SizedBox(height: 24),
                      Text(
                        _currentAffirmation,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF065643),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        height: 2,
                        width: 40,
                        color: const Color(0xFF065643).withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Bottom Interaction
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _nextAffirmation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1)),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.refresh_rounded, color: Color(0xFF065643), size: 20),
                            const SizedBox(width: 12),
                            Text(
                              "New Affirmation",
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF065643),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Take a deep breath and reflect.",
                      style: GoogleFonts.outfit(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
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
}
