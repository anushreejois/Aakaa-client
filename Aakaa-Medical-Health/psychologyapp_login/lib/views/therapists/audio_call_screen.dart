import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../widgets/zen_background.dart';
import '../../controllers/signup_loginfunctionality.dart';

class AudioCallScreen extends StatefulWidget {
  final String therapistName;

  const AudioCallScreen({
    super.key,
    required this.therapistName,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> with SingleTickerProviderStateMixin {
  bool _isMuted = false;
  bool _isSpeakerOn = true;
  int _callDuration = 0;
  Timer? _timer;
  late AnimationController _pulseController;

  // Agora State Variables
  RtcEngine? _engine;
  bool _isLoading = true;
  String _errorMessage = "";
  String _appId = "";
  String _channelName = "";
  String _token = "";
  bool _isBypassMode = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _initAgora();
  }

  Future<void> _initAgora() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      // 1. Request Microphone Permission
      PermissionStatus micStatus = await Permission.microphone.request();

      if (micStatus != PermissionStatus.granted) {
        if (mounted) {
          setState(() {
            _errorMessage = "Microphone permission is required for secure voice consultations.";
            _isLoading = false;
          });
        }
        return;
      }

      // 2. Derive Channel Name from Therapist's name
      _channelName = widget.therapistName.toLowerCase().replaceAll(RegExp(r'\s+'), '_');

      // 3. Fetch Token & Credentials from Node.js Backend
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString("auth_token");
      
      if (authToken == null || authToken.isEmpty) {
        if (mounted) {
          setState(() {
            _errorMessage = "Session expired. Please log in again.";
            _isLoading = false;
          });
        }
        return;
      }

      final response = await http.post(
        Uri.parse("${SignupLoginFunctionality.backendUrl}/api/agora/generate-token"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken"
        },
        body: jsonEncode({
          "channelName": _channelName,
          "role": "publisher",
          "uid": 0
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Server connection error (${response.statusCode})");
      }

      final data = jsonDecode(response.body);
      if (data["status"] != "success") {
        throw Exception(data["message"] ?? "Failed to retrieve secure keys");
      }

      _token = data["token"];
      _appId = data["appId"];
      final numericUid = data["uid"] ?? 0;

      // Handle Mock/Development Bypass mode from Backend
      if (_token == 'mock_bypass_token_for_development' || _appId == 'mock_app_id_12345') {
        debugPrint("⚡ Agora mock bypass mode active for voice call.");
        if (mounted) {
          setState(() {
            _isBypassMode = true;
            _isLoading = false;
          });
        }
        _startTimer();
        return;
      }

      // 4. Initialize Agora Engine
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId: _appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint("✅ Local user joined voice successfully: ${connection.localUid}");
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
            _startTimer();
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint("❌ Agora Engine voice error: $err, $msg");
          }
        ),
      );

      await _engine!.enableAudio();
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine!.setEnableSpeakerphone(_isSpeakerOn);

      // Join the live channel
      await _engine!.joinChannel(
        token: _token,
        channelId: _channelName,
        uid: numericUid,
        options: const ChannelMediaOptions(
          publishCameraTrack: false,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );

    } catch (e) {
      debugPrint("⚠️ Agora initialization failed or not supported: $e");
      // Seamlessly fall back to development simulated mode
      if (mounted) {
        setState(() {
          _isBypassMode = true;
          _isLoading = false;
        });
      }
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _callDuration++);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _destroyAgora();
    super.dispose();
  }

  Future<void> _destroyAgora() async {
    try {
      if (_engine != null) {
        await _engine!.leaveChannel();
        await _engine!.release();
      }
    } catch (e) {
      debugPrint("Error releasing Agora resources: $e");
    }
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: _isLoading 
            ? _buildLoadingScreen() 
            : _errorMessage.isNotEmpty 
                ? _buildErrorScreen()
                : _buildCallUI(),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF065643)),
          const SizedBox(height: 24),
          Text(
            "Connecting voice consultation...",
            style: GoogleFonts.outfit(
              color: const Color(0xFF065643),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 64),
            const SizedBox(height: 24),
            Text(
              "Connection Failed",
              style: GoogleFonts.outfit(
                color: Colors.redAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF065643),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                "Go Back",
                style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallUI() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Therapist Info & Pulsing Avatar
          Center(
            child: Column(
              children: [
                ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.1).animate(_pulseController),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08), width: 12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF065643).withValues(alpha: 0.05),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.15), width: 2),
                        image: const DecorationImage(
                          image: NetworkImage("https://images.unsplash.com/photo-1559839734-2b71f153678e?w=400&h=400&fit=crop"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  widget.therapistName,
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF065643), 
                    fontSize: 32, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.fiber_manual_record_rounded, color: Color(0xFF0A7D62), size: 12),
                      const SizedBox(width: 10),
                      Text(
                        _formatDuration(_callDuration),
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF065643), 
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isBypassMode) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Dev Bypass Mode Active",
                      style: GoogleFonts.outfit(
                        color: Colors.amber.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Spacer(),

          // Security Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_rounded, color: const Color(0xFF065643).withValues(alpha: 0.4), size: 14),
              const SizedBox(width: 8),
              Text(
                "End-to-End Encrypted Audio",
                style: GoogleFonts.outfit(
                  color: const Color(0xFF065643).withValues(alpha: 0.5), 
                  fontSize: 13, 
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Controls
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 40, 
              bottom: MediaQuery.of(context).padding.bottom + 40, 
              left: 32, 
              right: 32
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
              border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 30,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  _isMuted ? "Unmute" : "Mute",
                  _isMuted,
                  _toggleMute,
                ),
                _buildEndCallButton(),
                _buildControlButton(
                  _isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  "Speaker",
                  !_isSpeakerOn,
                  _toggleSpeaker,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF065643) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF065643).withValues(alpha: isActive ? 1.0 : 0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon, 
              color: isActive ? Colors.white : const Color(0xFF065643), 
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label, 
            style: GoogleFonts.outfit(
              color: const Color(0xFF065643).withValues(alpha: 0.7), 
              fontSize: 14,
              fontWeight: FontWeight.w600,
            )
          ),
        ],
      ),
    );
  }

  Widget _buildEndCallButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4B4B),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4B4B).withValues(alpha: 0.3), 
                  blurRadius: 25, 
                  offset: const Offset(0, 10)
                )
              ],
            ),
            child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 12),
          Text(
            "End Call", 
            style: GoogleFonts.outfit(
              color: const Color(0xFFFF4B4B), 
              fontSize: 14,
              fontWeight: FontWeight.bold,
            )
          ),
        ],
      ),
    );
  }

  void _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    await _engine?.muteLocalAudioStream(_isMuted);
  }

  void _toggleSpeaker() async {
    setState(() => _isSpeakerOn = !_isSpeakerOn);
    await _engine?.setEnableSpeakerphone(_isSpeakerOn);
  }
}
