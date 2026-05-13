import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class SleepSanctuaries extends StatefulWidget {
  const SleepSanctuaries({super.key});

  @override
  State<SleepSanctuaries> createState() => _SleepSanctuariesState();
}

class _SleepSanctuariesState extends State<SleepSanctuaries> {
  int _selectedSoundIndex = 0;
  bool _isPlaying = false;

  final List<Map<String, dynamic>> _sounds = [
    {"name": "Midnight Rain", "icon": Icons.umbrella_rounded, "color": Colors.blueGrey},
    {"name": "Zen Garden", "icon": Icons.spa_rounded, "color": Colors.teal},
    {"name": "Deep Ocean", "icon": Icons.waves_rounded, "color": Colors.indigo},
    {"name": "Forest Wind", "icon": Icons.air_rounded, "color": Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021B15), // Deep Midnight Green
      body: Stack(
        children: [
          // Ambient Starry Background Effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    const Color(0xFF065643).withOpacity(0.3),
                    const Color(0xFF021B15),
                  ],
                ),
              ),
            ),
          ),
          
          // Decorative Orbs
          Positioned(
            top: 200,
            left: -50,
            child: _buildOrb(300, const Color(0xFF0A7D62).withOpacity(0.05)),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white38, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Sleep Sanctuary",
                        style: GoogleFonts.outfit(color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 48), // Spacer
                    ],
                  ),
                ),

                const Spacer(),

                // Central Visualizer (Mock) - Slightly smaller for better fit
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: _isPlaying ? 1.0 : 0.0),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOutSine,
                  builder: (context, value, child) {
                    return Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.05 + (0.05 * value)), width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 160 + (20 * value),
                        height: 160 + (20 * value),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.02),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.02 * value),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          _sounds[_selectedSoundIndex]['icon'],
                          color: Colors.white.withOpacity(0.2 + (0.3 * value)),
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                Text(
                  _sounds[_selectedSoundIndex]['name'],
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  _isPlaying ? "Floating in peace..." : "Ready for rest?",
                  style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
                ),

                const Spacer(),

                // Play Button
                GestureDetector(
                  onTap: () => setState(() => _isPlaying = !_isPlaying),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Sound Selector
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _sounds.length,
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedSoundIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _selectedSoundIndex = index;
                          _isPlaying = true;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 70,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent),
                          ),
                          child: Icon(
                            _sounds[index]['icon'],
                            color: isSelected ? Colors.white : Colors.white24,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 100,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
