import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../widgets/zen_background.dart';
import '../controllers/plan_controller.dart';
import 'premium_gate_dialog.dart';

class SleepSanctuaries extends StatefulWidget {
  const SleepSanctuaries({super.key});

  @override
  State<SleepSanctuaries> createState() => _SleepSanctuariesState();
}

class _SleepSanctuariesState extends State<SleepSanctuaries> with TickerProviderStateMixin {
  // Tab controller: 0 = Curated, 1 = Ambient Studio
  int _activeTabIndex = 0;
  bool _isLoading = true;

  // Single player for curated solo tracks
  late AudioPlayer _curatedPlayer;
  bool _isPlayingCurated = false;
  int _activeCuratedIndex = -1;

  // Track structures for Curated Sanctuaries
  final List<Map<String, dynamic>> _curatedSanctuaries = [
    {
      "title": "Delta Wave Slumber",
      "desc": "Binaural theta frequencies for deep sleep cycles",
      "duration": "45m",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
      "color": const Color(0xFF0A7D62)
    },
    {
      "title": "Cosmic Healing Voyage",
      "desc": "Celestial sound pads mapping starry skies",
      "duration": "60m",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
      "color": const Color(0xFF065643)
    },
    {
      "title": "Rainfall Storm Retreat",
      "desc": "Direct storm capture for white-noise lovers",
      "duration": "30m",
      "url": "https://www.soundjay.com/nature/sounds/rain-07.mp3",
      "color": const Color(0xFFFF7A59)
    },
    {
      "title": "Solfeggio 528Hz Repair",
      "desc": "Binaural frequencies promoting cellular relaxation",
      "duration": "50m",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3",
      "color": const Color(0xFF0A7D62)
    },
    {
      "title": "Ocean Shore Slumber",
      "desc": "Direct night recording of waves crashing on shore",
      "duration": "40m",
      "url": "https://www.soundjay.com/nature/sounds/ocean-wave-1.mp3",
      "color": const Color(0xFF065643)
    }
  ];

  // Multiple players for Ambient Studio tracks
  final List<Map<String, dynamic>> _ambientSounds = [
    {"name": "Midnight Rain", "icon": Icons.umbrella_rounded, "enabled": false, "volume": 0.8},
    {"name": "Zen Garden", "icon": Icons.spa_rounded, "enabled": false, "volume": 0.5},
    {"name": "Deep Ocean", "icon": Icons.waves_rounded, "enabled": false, "volume": 0.5},
    {"name": "Forest Wind", "icon": Icons.air_rounded, "enabled": false, "volume": 0.5},
  ];

  final List<String> _ambientUrls = [
    "https://www.soundjay.com/nature/sounds/rain-07.mp3",
    "https://www.soundjay.com/nature/sounds/river-1.mp3",
    "https://www.soundjay.com/nature/sounds/ocean-wave-1.mp3",
    "https://www.soundjay.com/nature/sounds/wind-1.mp3",
  ];

  bool _isPlayingAmbient = false;
  late final List<AudioPlayer> _ambientPlayers;

  // Sleep Auto-Off Timer State
  Timer? _sleepTimer;
  int _sleepTimerSecondsRemaining = 0; // 0 = off

  // Animators for the Rotating Moon Visualizer
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );

    _initAudioEngines();
  }

  Future<void> _initAudioEngines() async {
    _curatedPlayer = AudioPlayer();
    _ambientPlayers = List.generate(4, (_) => AudioPlayer());
    
    try {
      // Preload curated loop listener
      _curatedPlayer.setLoopMode(LoopMode.one);
      
      // Load ambient players
      for (int i = 0; i < 4; i++) {
        await _ambientPlayers[i].setAudioSource(
          AudioSource.uri(Uri.parse(_ambientUrls[i])),
          preload: true,
        );
        await _ambientPlayers[i].setLoopMode(LoopMode.all);
        await _ambientPlayers[i].setVolume(_ambientSounds[i]['volume']);
      }
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("⚠️ Sleep audio engine loading exception: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    // Connect curated player status listener
    _curatedPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlayingCurated = state.playing;
        if (_isPlayingCurated) {
          _rotationController.repeat();
        } else {
          _rotationController.stop();
        }
      });
    });
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _rotationController.dispose();
    _curatedPlayer.dispose();
    for (var player in _ambientPlayers) {
      player.dispose();
    }
    super.dispose();
  }

  // Cross-Over prevention: stop ambient mix if curated plays (and vice versa)
  Future<void> _silenceAmbientStudio() async {
    setState(() {
      _isPlayingAmbient = false;
    });
    for (var player in _ambientPlayers) {
      if (player.playing) {
        await player.pause();
      }
    }
  }

  Future<void> _silenceCuratedSanctuaries() async {
    setState(() {
      _isPlayingCurated = false;
      _activeCuratedIndex = -1;
    });
    await _curatedPlayer.stop();
  }

  // Sleep Timer Mechanics
  void _setSleepTimer(int minutes) {
    HapticFeedback.mediumImpact();
    _sleepTimer?.cancel();
    
    if (minutes == 0) {
      setState(() {
        _sleepTimerSecondsRemaining = 0;
      });
      return;
    }

    setState(() {
      _sleepTimerSecondsRemaining = minutes * 60;
    });

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_sleepTimerSecondsRemaining > 0) {
        setState(() {
          _sleepTimerSecondsRemaining--;
        });
      } else {
        _triggerTimerShutDown();
      }
    });
  }

  void _triggerTimerShutDown() async {
    _sleepTimer?.cancel();
    HapticFeedback.heavyImpact();
    
    await _silenceAmbientStudio();
    await _silenceCuratedSanctuaries();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sleep Timer finished. Sanctuary silenced safely.", style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFF065643),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatTimerDisplay(int seconds) {
    if (seconds <= 0) return "Off";
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return "${mins}:${secs.toString().padLeft(2, '0')}";
  }

  // --- TAB A: CURATED SANCTUARIES METHODS ---
  Future<void> _playCuratedSanctuary(int index) async {
    bool isAllowed = PlanController.isSleepMixerAllowed;
    if (index > 0 && !isAllowed) {
      showDialog(
        context: context,
        builder: (_) => const PremiumAccessDialog(featureName: "VIP Guided Sleep Sanctuaries"),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    await _silenceAmbientStudio(); // Stop mixer overlapping

    try {
      if (_activeCuratedIndex == index && _isPlayingCurated) {
        // Pause
        await _curatedPlayer.pause();
      } else {
        // Launch new track
        setState(() {
          _activeCuratedIndex = index;
          _isLoading = true;
        });

        await _curatedPlayer.setUrl(_curatedSanctuaries[index]['url']);
        setState(() {
          _isLoading = false;
        });

        await _curatedPlayer.play();
        _openImmersivePlayer(index);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sanctuary stream offline. Try again later.", style: GoogleFonts.outfit())),
      );
    }
  }

  void _openImmersivePlayer(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final track = _curatedSanctuaries[index];
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7F5), // Soft Calming Daylight base
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // Dismiss handle
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
                  
                  // Active Track Label
                  Text(
                    "Immersive Sleep Sanctuary",
                    style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    track['title'],
                    style: GoogleFonts.outfit(color: const Color(0xFF065643), fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  
                  const SizedBox(height: 36),

                  // Glowing Moon Rotating Visualizer
                  RotationTransition(
                    turns: _rotationController,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: track['color'].withValues(alpha: 0.15),
                            blurRadius: 50,
                            spreadRadius: 8,
                          ),
                        ],
                        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08), width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Crescent Moon Center
                          Icon(Icons.nights_stay_rounded, color: track['color'], size: 80),
                          // Small stars scattered
                          Positioned(
                            top: 24,
                            left: 54,
                            child: Icon(Icons.star_rounded, color: const Color(0xFF065643).withValues(alpha: 0.25), size: 10),
                          ),
                          Positioned(
                            bottom: 30,
                            right: 48,
                            child: Icon(Icons.star_rounded, color: const Color(0xFF065643).withValues(alpha: 0.15), size: 8),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Media Stream Seeker
                  StreamBuilder<Duration>(
                    stream: _curatedPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = _curatedPlayer.duration ?? Duration.zero;
                      return Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 3,
                              activeTrackColor: track['color'],
                              inactiveTrackColor: const Color(0xFF065643).withValues(alpha: 0.08),
                              thumbColor: track['color'],
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                            ),
                            child: Slider(
                              value: position.inSeconds.toDouble(),
                              max: duration.inSeconds.toDouble() > 0 ? duration.inSeconds.toDouble() : 100.0,
                              onChanged: (val) {
                                _curatedPlayer.seek(Duration(seconds: val.toInt()));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.6), fontSize: 11),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.6), fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Playback Core Panel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous_rounded, color: Color(0xFF065643), size: 28),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          if (_isPlayingCurated) {
                            _curatedPlayer.pause();
                          } else {
                            _curatedPlayer.play();
                          }
                          setModalState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF065643),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: track['color'].withValues(alpha: 0.25), blurRadius: 20),
                            ],
                          ),
                          child: Icon(
                            _isPlayingCurated ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded, color: Color(0xFF065643), size: 28),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Sleep Countdown Timer Picker Row
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sleep Shutdown Timer",
                              style: GoogleFonts.outfit(color: const Color(0xFF065643), fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            if (_sleepTimerSecondsRemaining > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF7A59).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Silences in: ${_formatTimerDisplay(_sleepTimerSecondsRemaining)}",
                                  style: GoogleFonts.outfit(color: const Color(0xFFFF7A59), fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        children: [0, 15, 30, 60].map((mins) {
                          bool isActive = (mins == 0 && _sleepTimerSecondsRemaining == 0) ||
                                          (mins > 0 && _sleepTimerSecondsRemaining > (mins - 5) * 60 && _sleepTimerSecondsRemaining <= mins * 60);
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _setSleepTimer(mins);
                                setModalState(() {});
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isActive ? track['color'] : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isActive 
                                        ? track['color'] 
                                        : const Color(0xFF065643).withValues(alpha: 0.08),
                                  ),
                                  boxShadow: [
                                    if (!isActive)
                                      BoxShadow(
                                        color: const Color(0xFF065643).withValues(alpha: 0.03),
                                        blurRadius: 10,
                                      ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  mins == 0 ? "Off" : "${mins}m",
                                  style: GoogleFonts.outfit(
                                    color: isActive ? Colors.white : const Color(0xFF065643),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  // --- TAB B: AMBIENT STUDIO MIXER METHODS ---
  Future<void> _updateAmbientPlayState() async {
    try {
      for (int i = 0; i < 4; i++) {
        final player = _ambientPlayers[i];
        final isEnabled = _ambientSounds[i]['enabled'] && _isPlayingAmbient;
        if (isEnabled) {
          if (!player.playing) {
            await player.play();
          }
        } else {
          if (player.playing) {
            await player.pause();
          }
        }
      }
    } catch (e) {
      debugPrint("Error updating ambient track playback: $e");
    }
  }

  void _toggleAmbientSound(int index) async {
    bool isAllowed = PlanController.isSleepMixerAllowed;
    if (index > 0 && !isAllowed) {
      showDialog(
        context: context,
        builder: (_) => const PremiumAccessDialog(featureName: "Custom Zen Sleep Mixer tracks"),
      );
      return;
    }

    HapticFeedback.lightImpact();
    await _silenceCuratedSanctuaries(); // Prevent mix clashes

    setState(() {
      _ambientSounds[index]['enabled'] = !_ambientSounds[index]['enabled'];
      // Auto-toggle active player status
      bool hasActive = _ambientSounds.any((s) => s['enabled']);
      _isPlayingAmbient = hasActive;
    });

    await _updateAmbientPlayState();
  }

  void _updateAmbientVolume(int index, double vol) async {
    setState(() {
      _ambientSounds[index]['volume'] = vol;
    });
    try {
      await _ambientPlayers[index].setVolume(vol);
    } catch (e) {
      debugPrint("Error updating ambient volume: $e");
    }
  }

  // --- BUILD METRICS ---
  @override
  Widget build(BuildContext context) {
    bool isMixerAllowed = PlanController.isSleepMixerAllowed;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5), // Cohesive Calming Daylight base
      body: ZenBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF0A7D62)))
              : Column(
                  children: [
                    // Screen top header bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643), size: 22),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Sleep Sanctuary",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF065643),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF065643).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isMixerAllowed ? "VIP Sanctuary" : "Freemium Mode",
                              style: GoogleFonts.outfit(
                                color: isMixerAllowed ? const Color(0xFF0A7D62) : Colors.amber[900],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Nocturnal Tab Sliding Bar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.06)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF065643).withValues(alpha: 0.03),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() => _activeTabIndex = 0);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _activeTabIndex == 0 ? const Color(0xFF065643) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.nights_stay_rounded, 
                                      color: _activeTabIndex == 0 ? Colors.white : const Color(0xFF065643).withValues(alpha: 0.5), 
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Sanctuaries",
                                      style: GoogleFonts.outfit(
                                        color: _activeTabIndex == 0 ? Colors.white : const Color(0xFF065643).withValues(alpha: 0.6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() => _activeTabIndex = 1);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _activeTabIndex == 1 ? const Color(0xFF065643) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.tune_rounded, 
                                      color: _activeTabIndex == 1 ? Colors.white : const Color(0xFF065643).withValues(alpha: 0.5), 
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Ambient Mixer",
                                      style: GoogleFonts.outfit(
                                        color: _activeTabIndex == 1 ? Colors.white : const Color(0xFF065643).withValues(alpha: 0.6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Expanded Tab Content
                    Expanded(
                      child: IndexedStack(
                        index: _activeTabIndex,
                        children: [
                          // TAB 0: CURATED PLAYER VIEW
                          _buildCuratedSanctuariesTab(),
                          // TAB 1: AMBIENT STUDIO MIXER
                          _buildAmbientStudioTab(),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // --- TAB 0 DESIGN ---
  Widget _buildCuratedSanctuariesTab() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      itemCount: _curatedSanctuaries.length,
      itemBuilder: (context, index) {
        final track = _curatedSanctuaries[index];
        bool isPlayingThis = _activeCuratedIndex == index && _isPlayingCurated;
        bool isGated = index > 0 && !PlanController.isSleepMixerAllowed;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isPlayingThis ? track['color'].withValues(alpha: 0.4) : const Color(0xFF065643).withValues(alpha: 0.06),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF065643).withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: track['color'].withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isGated ? Icons.lock_outline_rounded : Icons.music_note_rounded,
                        color: isGated ? Colors.amber[950] : track['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track['title'],
                            style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            track['desc'],
                            style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.6), fontSize: 11.5, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFFFF7F5), height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, color: const Color(0xFF065643).withValues(alpha: 0.5), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          track['duration'],
                          style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.6), fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPlayingThis ? const Color(0xFFFF7A59).withValues(alpha: 0.15) : track['color'],
                        foregroundColor: isPlayingThis ? const Color(0xFFFF7A59) : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      icon: Icon(
                        isPlayingThis ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 16,
                      ),
                      label: Text(
                        isPlayingThis ? "Pause" : "Listen",
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      onPressed: () => _playCuratedSanctuary(index),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- TAB 1 DESIGN ---
  Widget _buildAmbientStudioTab() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Zen Sleep Mixer Studio",
                  style: GoogleFonts.outfit(color: const Color(0xFF065643), fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  "Blend multiple soothing nature ambient layers in real-time.",
                  style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.6), fontSize: 12),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Grid of Sound Mix Bubbles
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final track = _ambientSounds[index];
                bool isEnabled = track['enabled'] && _isPlayingAmbient;
                bool isGated = index > 0 && !PlanController.isSleepMixerAllowed;

                return GestureDetector(
                  onTap: () => _toggleAmbientSound(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      color: isEnabled 
                          ? const Color(0xFF0A7D62).withValues(alpha: 0.1) 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isEnabled 
                            ? const Color(0xFF0A7D62).withValues(alpha: 0.4) 
                            : const Color(0xFF065643).withValues(alpha: 0.06),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF065643).withValues(alpha: 0.03),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isEnabled ? const Color(0xFF0A7D62).withValues(alpha: 0.15) : const Color(0xFF065643).withValues(alpha: 0.04),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isGated ? Icons.lock_outline_rounded : track['icon'],
                            color: isGated 
                                ? Colors.amber[900] 
                                : (isEnabled ? const Color(0xFF0A7D62) : const Color(0xFF065643).withValues(alpha: 0.5)),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          track['name'],
                          style: GoogleFonts.outfit(
                            color: isEnabled ? const Color(0xFF065643) : const Color(0xFF065643).withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        if (isGated)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "VIP Premium",
                              style: GoogleFonts.outfit(color: Colors.amber[950], fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
              childCount: _ambientSounds.length,
            ),
          ),
        ),

        // Live Mixer Volume Adjustments Panel
        SliverPadding(
          padding: const EdgeInsets.all(24.0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  "Volume Levels",
                  style: GoogleFonts.outfit(color: const Color(0xFF065643), fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...List.generate(_ambientSounds.length, (index) {
                  final track = _ambientSounds[index];
                  bool isEnabled = track['enabled'] && _isPlayingAmbient;
                  if (!isEnabled) return const SizedBox.shrink(); // Show sliders only for active mixes

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
                    ),
                    child: Row(
                      children: [
                        Icon(track['icon'], color: const Color(0xFF0A7D62), size: 18),
                        const SizedBox(width: 12),
                        Text(
                          track['name'],
                          style: GoogleFonts.outfit(color: const Color(0xFF065643), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 3,
                              activeTrackColor: const Color(0xFF0A7D62),
                              inactiveTrackColor: const Color(0xFF065643).withValues(alpha: 0.08),
                              thumbColor: const Color(0xFF0A7D62),
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                            ),
                            child: Slider(
                              value: track['volume'],
                              onChanged: (val) => _updateAmbientVolume(index, val),
                            ),
                          ),
                        ),
                        Text(
                          "${(track['volume'] * 100).toInt()}%",
                          style: GoogleFonts.outfit(color: const Color(0xFF0A7D62), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
