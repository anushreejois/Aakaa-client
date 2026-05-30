import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';

class DailyAffirmation extends StatefulWidget {
  const DailyAffirmation({super.key});

  @override
  State<DailyAffirmation> createState() => _DailyAffirmationState();
}

class _DailyAffirmationState extends State<DailyAffirmation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<String> _affirmations = [
    "I am worthy of peace, happiness, and deep emotional rest.",
    "My potential is limitless, and I expand at my own beautiful pace.",
    "I choose to hold space for all my feelings and be exceptionally kind to myself today.",
    "I am resilient, strong, and brave enough to face whatever shifts my way.",
    "Every slow breath I take anchors my nervous system in absolute calm.",
    "I trust the natural, unfolding journey of my life.",
    "I am in charge of how I react, and today I choose peace and emotional safety.",
    "My challenges do not define me; they help me grow and evolve.",
    "I am completely enough, exactly as I am in this present moment.",
    "I radiate quiet confidence, self-respect, and deep inner harmony.",
    "I release the need to control the future and float peacefully in the now.",
    "My mind is a clear, open sky, and my thoughts are just passing clouds.",
    "I give myself permission to rest, recharge, and rebuild my energy.",
    "I honor my boundaries and speak my truth with quiet strength.",
    "I am proud of how far I have walked, even on the quietest days.",
    "I welcome healing and invite gentle, loving-kindness into my heart.",
    "My sensitivity is my superpower, allowing me to connect deeply and heal cleanly.",
    "I let go of past weight and step lightly into today's possibilities.",
    "I am supported by the ground beneath me and the air around me.",
    "I trust my inner wisdom to guide me through any uncertainty.",
    "I choose to let go of self-judgment and wrap my soul in self-compassion.",
    "I am building a life of balance, intentional peace, and quiet joy.",
    "My presence on this earth is meaningful, and my voice is worth hearing.",
    "I breathe in courage and breathe out old, stagnant worries.",
    "I choose to focus on the things I can nurture, and let go of the rest.",
    "I am patient with my healing, knowing that growth is a gentle spiral.",
    "I belong here, and I am safe in the sanctuary of my own skin.",
    "I possess the strength to navigate storms and the grace to enjoy the calm.",
    "My heart is open to receiving love, care, and supportive connections.",
    "I celebrate my quiet victories and honor my daily efforts.",
    "I release the expectation of perfection and embrace the beauty of being human.",
    "I am a source of light, warmth, and healing energy for myself and others.",
    "Every step I take is a step closer to my most authentic, peaceful self.",
    "I hold my head high, knowing my worth is inherent and unchanging.",
    "I am entering a season of soft beginnings, quiet strength, and deep alignment.",
    "I allow my mind to settle, knowing that I do not have to solve everything today.",
    "I choose to be my own safest haven, speaking to myself with soft, unfiltered kindness.",
    "My value is not tied to my productivity; I am worthy simply because I exist.",
    "I release the pressure to be perfect and welcome the freedom of being completely real.",
    "I am walking through my days with quiet grace, breathing space into my moments.",
    "I am gentle with my boundaries, knowing they are acts of love for my well-being.",
    "I choose to see the small glimmers of light today, anchoring my focus on hope.",
    "My body is a temple of resilience, and my breathing is a constant anchor of peace.",
    "I release ancient stories of who I used to be and write a fresh, gentle chapter today.",
    "I honor the pace of my healing, knowing that some days require only rest.",
    "I allow myself to feel, release, and grow into my strength at my own perfect pace.",
    "I choose to step away from noise, letting my mind rest in soft, restorative silence.",
    "I hold my dreams gently, knowing they will unfold in their own beautiful season.",
    "I am a calm harbor in my own storm, steady and rooted in my core peace.",
    "I walk forward with a quiet heart, completely aligned with my true inner sky."
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
        _currentAffirmation =
            _affirmations[Random().nextInt(_affirmations.length)];
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Color(0xFF065643), size: 28),
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
                      Icon(Icons.format_quote_rounded,
                          color: const Color(0xFF065643).withValues(alpha: 0.2),
                          size: 60),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color(0xFF065643)
                                  .withValues(alpha: 0.1)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 5))
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.refresh_rounded,
                                color: Color(0xFF065643), size: 20),
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
