import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';

class EmergencyGroundingLine extends StatefulWidget {
  const EmergencyGroundingLine({super.key});

  @override
  State<EmergencyGroundingLine> createState() => _EmergencyGroundingLineState();
}

// Model to represent a tactical touch ripple
class TouchRipple {
  final Offset position;
  double radius;
  double opacity;
  final Color color;

  TouchRipple({
    required this.position,
    required this.radius,
    required this.opacity,
    required this.color,
  });
}

class _EmergencyGroundingLineState extends State<EmergencyGroundingLine> with TickerProviderStateMixin {
  // Pacer Animation Controller
  late AnimationController _pacerController;
  late Animation<double> _pacerAnimation;

  // Frame Ticker for 60fps Tactile Ripples & Dynamic Waveforms
  late Ticker _frameTicker;
  List<TouchRipple> _ripples = [];
  double _animationTime = 0.0;

  String _breathingText = "Breathe In";
  String _currentCalmStream = "None";
  bool _isPlayingAudio = false;
  int _breathCycleCount = 0;

  // Calm Voice Note States
  bool _hasVoiceNote = false;
  bool _isRecording = false;
  bool _isPlayingVoiceNote = false;
  int _recordingDurationSeconds = 0;
  String _voiceNoteTimestamp = "";
  
  // SharedPreferences Instance
  SharedPreferences? _prefs;

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
    _initSharedPreferences();

    // 1. Setup Paced Breathing Circle
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

    // 2. Setup 60fps Frame Ticker for ripples and animated waves
    _frameTicker = createTicker((elapsed) {
      if (!mounted) return;
      setState(() {
        _animationTime = elapsed.inMilliseconds / 1000.0;
        
        // Update ripples: expand radius and fade out opacity
        _ripples = _ripples.map((r) {
          r.radius += 2.8;
          r.opacity -= 0.025;
          return r;
        }).where((r) => r.opacity > 0.0).toList();
      });
    });
    _frameTicker.start();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs != null && mounted) {
      setState(() {
        _hasVoiceNote = _prefs!.getBool('grounding_has_voice_note') ?? false;
        _recordingDurationSeconds = _prefs!.getInt('grounding_voice_note_duration') ?? 0;
        _voiceNoteTimestamp = _prefs!.getString('grounding_voice_note_time') ?? "";
      });
    }
  }

  @override
  void dispose() {
    _pacerController.dispose();
    _frameTicker.dispose();
    super.dispose();
  }

  // Handle tactile screen touch spawning a ripple + haptic trigger
  void _handleScreenTap(TapDownDetails details) {
    HapticFeedback.lightImpact(); // somatic vibration trigger
    
    // Choose ripple color matching the current emotional alignment phase
    Color rippleColor = Color.lerp(
      const Color(0xFFFF7A59),
      const Color(0xFF0A7D62),
      math.min(_breathCycleCount / 8.0, 1.0),
    )!.withValues(alpha: 0.8);

    setState(() {
      _ripples.add(
        TouchRipple(
          position: details.localPosition,
          radius: 10.0,
          opacity: 0.8,
          color: rippleColor,
        ),
      );
    });
  }

  // Simulate Recording of Future Self Guidance
  void _startRecordingVoiceNote() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isRecording = true;
      _recordingDurationSeconds = 0;
    });

    // Simulated seconds timer during active recording
    _updateRecordingTimer();
  }

  void _updateRecordingTimer() async {
    while (_isRecording && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (_isRecording && mounted) {
        setState(() {
          _recordingDurationSeconds++;
        });
      }
    }
  }

  Future<void> _stopRecordingAndSave() async {
    HapticFeedback.mediumImpact();
    
    final now = DateTime.now();
    final formattedTime = "${_getMonthName(now.month)} ${now.day}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    setState(() {
      _isRecording = false;
      _hasVoiceNote = true;
      _voiceNoteTimestamp = formattedTime;
    });

    if (_prefs != null) {
      await _prefs!.setBool('grounding_has_voice_note', true);
      await _prefs!.setInt('grounding_voice_note_duration', _recordingDurationSeconds);
      await _prefs!.setString('grounding_voice_note_time', formattedTime);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Calming Future Self Guidance note saved successfully!",
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0A7D62),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Future<void> _deleteVoiceNote() async {
    HapticFeedback.heavyImpact();
    setState(() {
      _hasVoiceNote = false;
      _isPlayingVoiceNote = false;
      _recordingDurationSeconds = 0;
      _voiceNoteTimestamp = "";
    });

    if (_prefs != null) {
      await _prefs!.setBool('grounding_has_voice_note', false);
      await _prefs!.remove('grounding_voice_note_duration');
      await _prefs!.remove('grounding_voice_note_time');
    }
  }

  void _togglePlayVoiceNote() {
    HapticFeedback.lightImpact();
    setState(() {
      _isPlayingVoiceNote = !_isPlayingVoiceNote;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isPlayingVoiceNote
              ? "Streaming your voice: Focus on your grounding reminder..."
              : "Voice guidance paused.",
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF065643),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
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
      body: GestureDetector(
        onTapDown: _handleScreenTap,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Custom Painter to draw 60fps dynamic tactile ripples
            Positioned.fill(
              child: CustomPaint(
                painter: RipplePainter(ripples: _ripples),
              ),
            ),
            
            // Core screen content
            ZenBackground(
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
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            ScaleTransition(
                              scale: _pacerAnimation,
                              child: Container(
                                height: 140,
                                width: 140,
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
                                  height: 100,
                                  width: 100,
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
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
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
                              "Completed Cycles: $_breathCycleCount  •  Tap background to ripple",
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: const Color(0xFF065643).withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Calm Voice Note Suite (Premium Section)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      sliver: SliverToBoxAdapter(
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF065643).withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFF065643).withValues(alpha: 0.08),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.record_voice_over_rounded, 
                                      color: _isRecording ? const Color(0xFFFF7A59) : const Color(0xFF0A7D62),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isRecording ? "Recording Guidance Note..." : "My Safe-Harbor Voice Note",
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xFF065643),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (_hasVoiceNote && !_isRecording)
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                        onPressed: _deleteVoiceNote,
                                        tooltip: "Delete Voice Note",
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Case 1: Active Recording
                                if (_isRecording) ...[
                                  Text(
                                    "Speak directly and slowly. Remind your future self that this moment will pass, and you are completely safe.",
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF065643).withValues(alpha: 0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // 60fps dynamic mechanical sound wave simulator
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(21, (index) {
                                      double waveFactor = math.sin(_animationTime * 6.0 + index) * 18.0;
                                      double height = 24.0 + waveFactor.abs();
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                                        width: 3.5,
                                        height: height,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF7A59).withValues(alpha: 0.85),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Duration: ${_recordingDurationSeconds.toString().padLeft(2, '0')}s",
                                        style: GoogleFonts.outfit(
                                          color: const Color(0xFF065643),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF065643),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        ),
                                        icon: const Icon(Icons.stop_rounded),
                                        label: Text("Save Note", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                                        onPressed: _stopRecordingAndSave,
                                      ),
                                    ],
                                  ),
                                ]

                                // Case 2: Voice Note Exists
                                else if (_hasVoiceNote) ...[
                                  Text(
                                    "Saved on $_voiceNoteTimestamp • Duration: ${_recordingDurationSeconds}s",
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF065643).withValues(alpha: 0.6),
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Animated sound wave when playing back
                                  if (_isPlayingVoiceNote) ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(15, (index) {
                                        double waveFactor = math.sin(_animationTime * 4.0 + index * 1.5) * 12.0;
                                        double height = 12.0 + waveFactor.abs();
                                        return Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 3),
                                          width: 3,
                                          height: height,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0A7D62).withValues(alpha: 0.8),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _isPlayingVoiceNote 
                                              ? "Breathing in rhythm with your recorded guidance..." 
                                              : "Click play to listen to your grounding guidance note.",
                                          style: GoogleFonts.outfit(
                                            color: const Color(0xFF065643),
                                            fontSize: 12,
                                            fontStyle: _isPlayingVoiceNote ? FontStyle.italic : FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _isPlayingVoiceNote ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                                          color: const Color(0xFF0A7D62),
                                          size: 40,
                                        ),
                                        onPressed: _togglePlayVoiceNote,
                                      ),
                                    ],
                                  ),
                                ]

                                // Case 3: Empty State (Need to Record)
                                else ...[
                                  Text(
                                    "Log a voice note to yourself while feeling fully calm. When you experience distress later, listening to your own secure voice is highly therapeutic.",
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF065643).withValues(alpha: 0.7),
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0A7D62).withValues(alpha: 0.1),
                                        foregroundColor: const Color(0xFF0A7D62),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          side: const BorderSide(color: Color(0xFF0A7D62), width: 1.2),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      icon: const Icon(Icons.mic_rounded, size: 18),
                                      label: Text(
                                        "Record Future Self Guidance",
                                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      onPressed: _startRecordingVoiceNote,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
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
                            const SizedBox(height: 8),
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
          ],
        ),
      ),
    );
  }
}

// 60fps Custom Painter for tactile glowing ripples
class RipplePainter extends CustomPainter {
  final List<TouchRipple> ripples;

  RipplePainter({required this.ripples});

  @override
  void paint(Canvas canvas, Size size) {
    for (var ripple in ripples) {
      final paint = Paint()
        ..color = ripple.color.withValues(alpha: ripple.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      // Draw the concentric circles for the visual tactile effect
      canvas.drawCircle(ripple.position, ripple.radius, paint);
      
      // Draw outer secondary ripple at slightly smaller opacity
      if (ripple.radius > 20) {
        final outerPaint = Paint()
          ..color = ripple.color.withValues(alpha: ripple.opacity * 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawCircle(ripple.position, ripple.radius - 12.0, outerPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) => true;
}
