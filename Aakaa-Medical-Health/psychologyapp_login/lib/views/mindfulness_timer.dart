import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import '../widgets/zen_background.dart';
import '../controllers/activity_controller.dart';

class MindfulnessTimer extends StatefulWidget {
  const MindfulnessTimer({super.key});

  @override
  State<MindfulnessTimer> createState() => _MindfulnessTimerState();
}

class _MindfulnessTimerState extends State<MindfulnessTimer> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _scaleAnimation;
  late AudioPlayer _audioPlayer;
  
  // Timer settings
  int _selectedMinutes = 5;
  int _secondsRemaining = 300; 
  bool _isStarted = false;
  Timer? _timer;
  String _breathText = "Breathe in...";

  // Background Audio Channels
  int _selectedTrackIndex = 0;
  bool _audioLoading = false;

  final List<Map<String, dynamic>> _audioTracks = [
    {
      "name": "Silent Focus",
      "subtitle": "Pure visual guides & quietness",
      "icon": Icons.volume_off_rounded,
      "url": ""
    },
    {
      "name": "Vocal Guidance Coach",
      "subtitle": "Soothing voice posture checkpoints",
      "icon": Icons.record_voice_over_rounded,
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3" // Premium guide stream
    },
    {
      "name": "Ambient Forest Rain",
      "subtitle": "Immersive nature ambient loop",
      "icon": Icons.grain_rounded,
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3" // Calming ambient stream
    }
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // 1. Breathing Circle Animators
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addStatusListener((status) {
        if (!mounted) return;
        if (status == AnimationStatus.completed) {
          setState(() => _breathText = "And hold...");
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted && _isStarted) {
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

  @override
  void dispose() {
    _breathingController.dispose();
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Update selected session length
  void _changeDuration(int minutes) {
    if (_isStarted) return; // Prevent toggling when timer runs
    HapticFeedback.lightImpact();
    setState(() {
      _selectedMinutes = minutes;
      _secondsRemaining = minutes * 60;
    });
  }

  // Handle Play/Pause + Audio Stream Initialization
  Future<void> _toggleTimer() async {
    HapticFeedback.mediumImpact();
    
    if (_isStarted) {
      // Pause
      setState(() {
        _isStarted = false;
        _breathingController.stop();
        _timer?.cancel();
      });
      await _audioPlayer.pause();
    } else {
      // Start
      setState(() {
        _isStarted = true;
        _breathingController.forward();
        _startCountdown();
      });
      _playSelectedTrack();
    }
  }

  Future<void> _playSelectedTrack() async {
    final track = _audioTracks[_selectedTrackIndex];
    if (track['url'].isEmpty) {
      await _audioPlayer.stop();
      return;
    }

    setState(() => _audioLoading = true);
    try {
      await _audioPlayer.setUrl(track['url']);
      await _audioPlayer.setLoopMode(LoopMode.one);
      if (_isStarted) {
        await _audioPlayer.play();
      }
    } catch (e) {
      // Audio network fail-safe
      debugPrint("❌ Mindfulness Timer Audio Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Audio error: $e. Standard visual timer remains active.", style: GoogleFonts.outfit()),
          backgroundColor: Colors.orange[800],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _audioLoading = false);
      }
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _completeSession();
      }
    });
  }

  Future<void> _completeSession() async {
    setState(() {
      _isStarted = false;
      _breathingController.stop();
      _timer?.cancel();
    });
    await _audioPlayer.stop();
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    HapticFeedback.mediumImpact();
    
    // Dynamic database minutes logging
    ActivityController.incrementMindfulMinutes(_selectedMinutes);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF7F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: Row(
          children: [
            const Icon(Icons.spa_rounded, color: Color(0xFF0A7D62)),
            const SizedBox(width: 10),
            Text(
              "Beautifully Grounded!",
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF065643), fontSize: 18),
            ),
          ],
        ),
        content: Text(
          "You've completed your $_selectedMinutes-minute daily mindfulness loop. Your activity streak and dashboard growth levels have been updated.",
          style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.8), fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _secondsRemaining = _selectedMinutes * 60;
              });
            },
            child: Text(
              "Return to Sanctuary",
              style: GoogleFonts.outfit(color: const Color(0xFF0A7D62), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Open Glassmorphic Sliding Instruction Sheet
  void _openMeditationGuide() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: const BoxDecoration(
            color: Color(0xFFFFF7F5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF065643).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Somatic Meditation Walkthrough",
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065643),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Aligning physical presence with mental focus",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: const Color(0xFF065643).withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Item 1: Posture
                _buildGuideCard(
                  icon: Icons.accessibility_new_rounded,
                  title: "1. Posture Realignment",
                  desc: "Sit comfortably, drop your shoulders down, and let your spine align tall like a bamboo stem. Put your hands loosely on your lap.",
                ),
                const SizedBox(height: 16),
                
                // Item 2: Box Breathing
                _buildGuideCard(
                  icon: Icons.circle_outlined,
                  title: "2. Visual Breath Synchronization",
                  desc: "Watch the central ring. As it expands, draw your breath deep into your diaphragm. Hold for 1 second at the peak, then slowly release as it contracts.",
                ),
                const SizedBox(height: 16),
                
                // Item 3: Labeling
                _buildGuideCard(
                  icon: Icons.psychology_rounded,
                  title: "3. Cognitive Thought Labeling",
                  desc: "When distracting thoughts pop up, don't fight them. Simply label them silently (e.g., 'thinking', 'worrying') and gently steer your awareness back to the breathing rhythm.",
                ),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF065643),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Begin Practicing", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuideCard({required IconData icon, required String title, required String desc}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0A7D62).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0A7D62), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF065643), fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.7), fontSize: 11.5, height: 1.4),
                ),
              ],
            ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Top Bar Navigation
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643), size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Mindfulness Sanctuary",
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Duration Selector Segment (Beautifully Arranged Chips)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Session Duration",
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF065643).withValues(alpha: 0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [5, 10, 15].map((mins) {
                          bool isSelected = _selectedMinutes == mins;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _changeDuration(mins),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF065643) : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected 
                                        ? const Color(0xFF065643) 
                                        : const Color(0xFF065643).withValues(alpha: 0.08),
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: const Color(0xFF065643).withValues(alpha: 0.15),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "$mins Min",
                                  style: GoogleFonts.outfit(
                                    color: isSelected ? Colors.white : const Color(0xFF065643),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              // Dynamic Concentric Breathing Circle Pacer
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ring
                              Container(
                                width: 180 * _scaleAnimation.value,
                                height: 180 * _scaleAnimation.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF0A7D62).withValues(alpha: 0.05),
                                  border: Border.all(color: const Color(0xFF0A7D62).withValues(alpha: 0.15), width: 1),
                                ),
                              ),
                              // Inner ring
                              Container(
                                width: 130 * _scaleAnimation.value,
                                height: 130 * _scaleAnimation.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF065643).withValues(alpha: 0.06),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                  border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
                                ),
                                child: const Icon(Icons.spa_rounded, color: Color(0xFF0A7D62), size: 36),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 36),
                      Text(
                        _breathText,
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF065643),
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTime(_secondsRemaining),
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF065643).withValues(alpha: 0.5),
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Audio Guided Channel Row (Premium)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Guided Audio Accompaniment",
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF065643).withValues(alpha: 0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_audioTracks.length, (index) {
                        final track = _audioTracks[index];
                        bool isSelected = _selectedTrackIndex == index;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF0A7D62).withValues(alpha: 0.05) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected 
                                  ? const Color(0xFF0A7D62).withValues(alpha: 0.3) 
                                  : const Color(0xFF065643).withValues(alpha: 0.06),
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF0A7D62).withValues(alpha: 0.1) : const Color(0xFF065643).withValues(alpha: 0.04),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                track['icon'], 
                                color: isSelected ? const Color(0xFF0A7D62) : const Color(0xFF065643).withValues(alpha: 0.6), 
                                size: 18,
                              ),
                            ),
                            title: Text(
                              track['name'],
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF065643),
                                fontSize: 13.5,
                              ),
                            ),
                            subtitle: Text(
                              track['subtitle'],
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF065643).withValues(alpha: 0.6),
                                fontSize: 10.5,
                              ),
                            ),
                            trailing: isSelected && _audioLoading
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0A7D62)))
                                : Radio<int>(
                                    value: index,
                                    groupValue: _selectedTrackIndex,
                                    activeColor: const Color(0xFF0A7D62),
                                    onChanged: _isStarted ? null : (val) {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        _selectedTrackIndex = val!;
                                      });
                                    },
                                  ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Bottom Guideline & Trigger Actions
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Trigger Button
                      GestureDetector(
                        onTap: _toggleTimer,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFF065643),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF065643).withValues(alpha: 0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            _isStarted ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Expandable Guide trigger
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF065643),
                          side: BorderSide(color: const Color(0xFF065643).withValues(alpha: 0.15)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        icon: const Icon(Icons.menu_book_rounded, size: 18),
                        label: Text("Open Meditation Instruction Guide", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
                        onPressed: _openMeditationGuide,
                      ),
                      const SizedBox(height: 48),
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
