import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';
import '../controllers/plan_controller.dart';
import 'premium_gate_dialog.dart';

class SleepSanctuaries extends StatefulWidget {
  const SleepSanctuaries({super.key});

  @override
  State<SleepSanctuaries> createState() => _SleepSanctuariesState();
}

class _SleepSanctuariesState extends State<SleepSanctuaries> {
  // Track structures with state and volume level
  final List<Map<String, dynamic>> _sounds = [
    {"name": "Midnight Rain", "icon": Icons.umbrella_rounded, "enabled": true, "volume": 0.8},
    {"name": "Zen Garden", "icon": Icons.spa_rounded, "enabled": false, "volume": 0.5},
    {"name": "Deep Ocean", "icon": Icons.waves_rounded, "enabled": false, "volume": 0.5},
    {"name": "Forest Wind", "icon": Icons.air_rounded, "enabled": false, "volume": 0.5},
  ];

  bool _isPlaying = false;

  void _toggleSound(int index) {
    bool isAllowed = PlanController.isSleepMixerAllowed;

    if (index == 0) {
      // Midnight Rain is free
      setState(() {
        _sounds[index]['enabled'] = !_sounds[index]['enabled'];
        if (_sounds[index]['enabled']) _isPlaying = true;
      });
    } else {
      // Gated for Basic+
      if (isAllowed) {
        setState(() {
          _sounds[index]['enabled'] = !_sounds[index]['enabled'];
          if (_sounds[index]['enabled']) _isPlaying = true;
        });
      } else {
        showDialog(
          context: context,
          builder: (_) => const PremiumAccessDialog(featureName: "Custom Zen Sleep Mixer tracks"),
        );
      }
    }
  }

  void _updateVolume(int index, double newVol) {
    if (!PlanController.isSleepMixerAllowed && index > 0) return;
    setState(() {
      _sounds[index]['volume'] = newVol;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAllowed = PlanController.isSleepMixerAllowed;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep nocturnal slate black
      body: ZenBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Top navigation header bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Sleep Sanctuary",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isAllowed ? "Studio Active" : "Freemium Track",
                          style: GoogleFonts.outfit(
                            color: isAllowed ? const Color(0xFF80DEEA) : Colors.amberAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Visualizer Ring
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: _isPlaying ? 1.0 : 0.0),
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeInOutSine,
                      builder: (context, value, child) {
                        return Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF00E5FF).withValues(alpha: 0.03 + (0.07 * value)),
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: 150 + (15 * value),
                            height: 150 + (15 * value),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF1E293B),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00E5FF).withValues(alpha: 0.05 + (0.1 * value)),
                                  blurRadius: 30,
                                  spreadRadius: 2 + (8 * value),
                                  offset: const Offset(0, 0),
                                ),
                              ],
                              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                            ),
                            child: Icon(
                              Icons.nights_stay_rounded,
                              color: const Color(0xFF80DEEA).withValues(alpha: 0.7 + (0.3 * value)),
                              size: 50 + (5 * value),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isPlaying ? "Multi-Track Mixer Active" : "Sanctuary Silenced",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isPlaying ? "Floating in custom comfort..." : "Blend your ideal nightly soundscape",
                      style: GoogleFonts.outfit(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Main Play/Pause Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                          // If play is triggered, ensure at least one track is on
                          if (_isPlaying) {
                            bool hasActive = _sounds.any((s) => s['enabled']);
                            if (!hasActive) {
                              _sounds[0]['enabled'] = true;
                            }
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: const Color(0xFF0F172A),
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Mixer Sliders Section
              SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ambient Studio Controls",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(_sounds.length, (index) {
                        final track = _sounds[index];
                        final bool isEnabled = track['enabled'] && _isPlaying;
                        final bool isLocked = !isAllowed && index > 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B).withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isEnabled 
                                  ? const Color(0xFF00E5FF).withValues(alpha: 0.2) 
                                  : Colors.white.withValues(alpha: 0.03),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Toggle Button
                              GestureDetector(
                                onTap: () => _toggleSound(index),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isLocked 
                                        ? Colors.white.withValues(alpha: 0.02)
                                        : (isEnabled 
                                            ? const Color(0xFF00E5FF).withValues(alpha: 0.15) 
                                            : Colors.white.withValues(alpha: 0.05)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isLocked ? Icons.lock_outline_rounded : track['icon'],
                                    color: isLocked 
                                        ? Colors.grey[600] 
                                        : (isEnabled ? const Color(0xFF00E5FF) : Colors.grey[400]),
                                    size: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Track info + slider
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          track['name'],
                                          style: GoogleFonts.outfit(
                                            color: isLocked ? Colors.grey[600] : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        if (isLocked)
                                          Text(
                                            "Premium Gated",
                                            style: GoogleFonts.outfit(
                                              color: Colors.amberAccent,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        else if (isEnabled)
                                          Text(
                                            "${(track['volume'] * 100).toInt()}%",
                                            style: GoogleFonts.outfit(
                                              color: const Color(0xFF00E5FF),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Glassmorphic slider
                                    SliderTheme(
                                      data: SliderThemeData(
                                        trackHeight: 4,
                                        activeTrackColor: const Color(0xFF00E5FF),
                                        inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                                        thumbColor: const Color(0xFF00E5FF),
                                        overlayColor: const Color(0xFF00E5FF).withValues(alpha: 0.1),
                                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                                      ),
                                      child: Slider(
                                        value: track['volume'],
                                        onChanged: isLocked 
                                            ? null 
                                            : (newVol) => _updateVolume(index, newVol),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 40),
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
