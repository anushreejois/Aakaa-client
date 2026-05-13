import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class AffirmationDeck extends StatefulWidget {
  const AffirmationDeck({super.key});

  @override
  State<AffirmationDeck> createState() => _AffirmationDeckState();
}

class _AffirmationDeckState extends State<AffirmationDeck> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  double _currentPage = 0;

  final List<Map<String, String>> _affirmations = [
    {"text": "I am worthy of all the good things coming my way.", "author": "Self-Love"},
    {"text": "My mind is calm, and my heart is at peace.", "author": "Zen"},
    {"text": "I have the power to create the life I desire.", "author": "Empowerment"},
    {"text": "I breathe in courage and breathe out fear.", "author": "Inner Strength"},
    {"text": "I am enough, exactly as I am.", "author": "Acceptance"},
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: Stack(
        children: [
          // Background soft gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF7F5), Color(0xFFFFEFEA)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Affirmation Deck",
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                        ),
                      ),
                      Text(
                        "Swipe to manifest your truth.",
                        style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _affirmations.length,
                    itemBuilder: (context, index) {
                      double scale = (1 - (_currentPage - index).abs() * 0.1).clamp(0.8, 1.0);
                      return _buildAffirmationCard(_affirmations[index], scale);
                    },
                  ),
                ),
                
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationCard(Map<String, String> data, double scale) {
    return Transform.scale(
      scale: scale,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF065643), Color(0xFF0A7D62)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF065643).withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative shapes
            Positioned(
              top: -20,
              right: -20,
              child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.05)),
            ),
            
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.format_quote_rounded, color: Colors.white24, size: 60),
                  const SizedBox(height: 20),
                  Text(
                    data['text']!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data['author']!.toUpperCase(),
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
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
