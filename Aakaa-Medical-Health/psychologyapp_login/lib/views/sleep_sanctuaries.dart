import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';

class SleepSanctuaries extends StatefulWidget {
  const SleepSanctuaries({super.key});

  @override
  State<SleepSanctuaries> createState() => _SleepSanctuariesState();
}

class _SleepSanctuariesState extends State<SleepSanctuaries> {
  int _selectedSoundIndex = 0;
  bool _isPlaying = false;

  final List<Map<String, dynamic>> _sounds = [
    {"name": "Midnight Rain", "icon": Icons.umbrella_rounded},
    {"name": "Zen Garden", "icon": Icons.spa_rounded},
    {"name": "Deep Ocean", "icon": Icons.waves_rounded},
    {"name": "Forest Wind", "icon": Icons.air_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF065643), size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Sleep Sanctuary",
                      style: GoogleFonts.outfit(color: const Color(0xFF065643), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 48), // Spacer
                  ],
                ),
              ),

              const Spacer(),

              // Central Visualizer
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: _isPlaying ? 1.0 : 0.0),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOutSine,
                builder: (context, value, child) {
                  return Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05 + (0.1 * value)), width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 170 + (20 * value),
                      height: 170 + (20 * value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF065643).withValues(alpha: 0.08 + (0.08 * value)),
                            blurRadius: 35,
                            spreadRadius: 5 + (10 * value),
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
                      ),
                      child: Icon(
                        _sounds[_selectedSoundIndex]['icon'],
                        color: const Color(0xFF065643).withValues(alpha: 0.7 + (0.3 * value)),
                        size: 60 + (5 * value),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 36),

              Text(
                _sounds[_selectedSoundIndex]['name'],
                style: GoogleFonts.outfit(
                  color: const Color(0xFF065643),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                _isPlaying ? "Floating in peace..." : "Ready for rest?",
                style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.6), fontSize: 16, fontWeight: FontWeight.w500),
              ),

              const Spacer(),

              // Play Button
              GestureDetector(
                onTap: () => setState(() => _isPlaying = !_isPlaying),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF065643).withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Sound Selector
              SizedBox(
                height: 85,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
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
                        duration: const Duration(milliseconds: 250),
                        width: 75,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                          color: isSelected ? null : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected ? const Color(0xFF065643).withValues(alpha: 0.25) : const Color(0xFF065643).withValues(alpha: 0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: Border.all(color: isSelected ? Colors.transparent : const Color(0xFF065643).withValues(alpha: 0.05)),
                        ),
                        child: Icon(
                          _sounds[index]['icon'],
                          color: isSelected ? Colors.white : const Color(0xFF065643).withValues(alpha: 0.6),
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
