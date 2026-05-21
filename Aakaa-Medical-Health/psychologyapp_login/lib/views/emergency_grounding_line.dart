import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';

class EmergencyGroundingLine extends StatefulWidget {
  const EmergencyGroundingLine({super.key});

  @override
  State<EmergencyGroundingLine> createState() => _EmergencyGroundingLineState();
}

class _EmergencyGroundingLineState extends State<EmergencyGroundingLine> with SingleTickerProviderStateMixin {
  // Pacer Animation Controller
  late AnimationController _pacerController;
  late Animation<double> _pacerAnimation;
  
  String _breathingText = "Breathe In";
  String _currentCalmStream = "None";
  bool _isPlayingAudio = false;
  int _breathCycleCount = 0;

  // Curated grounding somatic guides
  final List<Map<String, dynamic>> _somaticGuides = [
    {
      "title": "5-4-3-2-1 Sensory Grounding",
      "subtitle": "Engage sight, touch, hearing, smell, taste",
      "icon": Icons.remove_red_eye_rounded,
      "color": const Color(0xFF0A7D62)
    },
    {
      "title": "Vagus Nerve Stimulation",
      "subtitle": "Slow heart rate & activate parasympathetic calm",
      "icon": Icons.graphic_eq_rounded,
      "color": const Color(0xFF065643)
    },
    {
      "title": "Panic Override Breathwork",
      "subtitle": "Immediate somatic calming sequence",
      "icon": Icons.favorite_rounded,
      "color": const Color(0xFFFF7A59)
    }
  ];

  @override
  void initState() {
    super.initState();
    _pacerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _pacerAnimation = Tween<double>(begin: 0.9, end: 1.6).animate(
      CurvedAnimation(parent: _pacerController, curve: Curves.easeInOutSine),
    );

    _pacerController.addStatusListener((status) {
      if (!mounted) return;
      if (status == AnimationStatus.completed) {
        setState(() {
          _breathingText = "Breathe Out";
          _breathCycleCount++;
        });
        _pacerController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _breathingText = "Breathe In";
        });
        _pacerController.forward();
      }
    });

    _pacerController.forward();
  }

  @override
  void dispose() {
    _pacerController.dispose();
    super.dispose();
  }

  void _triggerCalmStream(String name) {
    setState(() {
      if (_currentCalmStream == name && _isPlayingAudio) {
        _isPlayingAudio = false;
        _currentCalmStream = "None";
      } else {
        _currentCalmStream = name;
        _isPlayingAudio = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isPlayingAudio 
              ? "Playing Somatic Guide: $name..." 
              : "Calming guide stopped.",
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF065643),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color.lerp(
      const Color(0xFFFF7A59), // Aakaa warm coral (High distress warning phase)
      const Color(0xFF0A7D62), // Soothing therapeutic green (Calmed phase)
      math.min(_breathCycleCount / 8.0, 1.0),
    )!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ZenBackground(
        child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top navigation
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Grounding Hotline",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.health_and_safety_rounded, color: primaryColor, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            "VIP SOS",
                            style: GoogleFonts.outfit(
                              color: primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Paced Breathing Circle Segment
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: _pacerAnimation,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withValues(alpha: 0.08),
                          border: Border.all(color: primaryColor.withValues(alpha: 0.3), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.15),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withValues(alpha: 0.15),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _breathingText,
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF065643),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      "Paced Grounding Breaths",
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Completed Cycles: $_breathCycleCount  •  Sync your body to the pulse",
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: const Color(0xFF065643).withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Clinical Somatic Audio Streamers
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Somatic Audio Broadcasters",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF065643),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._somaticGuides.map((guide) {
                      bool isCurrent = _currentCalmStream == guide['title'] && _isPlayingAudio;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF065643).withValues(alpha: 0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: isCurrent 
                                ? guide['color'].withValues(alpha: 0.4) 
                                : const Color(0xFF065643).withValues(alpha: 0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: guide['color'].withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(guide['icon'], color: guide['color'], size: 22),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    guide['title'],
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF065643),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    guide['subtitle'],
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF065643).withValues(alpha: 0.6),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isCurrent ? Icons.stop_circle_rounded : Icons.play_circle_fill_rounded,
                                color: isCurrent ? Colors.redAccent : guide['color'],
                                size: 36,
                              ),
                              onPressed: () => _triggerCalmStream(guide['title']),
                            ),
                          ],
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 24),

                    // Dedicated SOS Clinic Hotline
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Clinical Safe Guard Hotline",
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Instantly speak directly to a standby counselor or emergency doctor",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Emergency call initiated with standby counselor...", style: GoogleFonts.outfit(color: Colors.white)),
                                  backgroundColor: const Color(0xFF065643),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                "CALL NOW",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF065643),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
