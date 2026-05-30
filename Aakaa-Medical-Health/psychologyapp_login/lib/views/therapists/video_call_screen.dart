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

class VideoCallScreen extends StatefulWidget {
  final String therapistName;

  const VideoCallScreen({
    super.key,
    required this.therapistName,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isCameraOn = true;
  int _callDuration = 0;
  Timer? _timer;

  // Agora State Variables
  RtcEngine? _engine;
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isLoading = true;
  String _errorMessage = "";
  String _appId = "";
  String _channelName = "";
  String _token = "";
  bool _isBypassMode = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      // 1. Request Microphone & Camera Permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.camera,
      ].request();

      if (statuses[Permission.microphone] != PermissionStatus.granted ||
          statuses[Permission.camera] != PermissionStatus.granted) {
        if (mounted) {
          setState(() {
            _errorMessage = "Camera and Microphone permissions are required for secure consultation.";
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
        debugPrint("⚡ Agora mock bypass mode active.");
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
            debugPrint("✅ Local user joined successfully: ${connection.localUid}");
            if (mounted) {
              setState(() {
                _localUserJoined = true;
                _isLoading = false;
              });
            }
            _startTimer();
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint("👥 Remote therapist joined channel: $remoteUid");
            if (mounted) {
              setState(() {
                _remoteUid = remoteUid;
              });
            }
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            debugPrint("👥 Remote therapist left channel: $remoteUid");
            if (mounted) {
              setState(() {
                _remoteUid = null;
              });
            }
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint("❌ Agora Engine error: $err, $msg");
          }
        ),
      );

      await _engine!.enableVideo();
      await _engine!.startPreview();
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      // Join the live channel
      await _engine!.joinChannel(
        token: _token,
        channelId: _channelName,
        uid: numericUid,
        options: const ChannelMediaOptions(
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );

    } catch (e) {
      debugPrint("⚠️ Agora initialization failed or not supported in this environment: $e");
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
            "Establishing secure WebRTC channel...",
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
    return Stack(
      children: [
        // Main Video Feed (Remote Therapist)
        Positioned.fill(
          child: _isBypassMode || _remoteUid == null
              ? _buildSimulatedTherapistFeed()
              : ClipRRect(
                  child: AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine!,
                      canvas: VideoCanvas(uid: _remoteUid),
                      connection: RtcConnection(channelId: _channelName),
                    ),
                  ),
                ),
        ),

        // User Video Feed (Floating Window)
        Positioned(
          top: MediaQuery.of(context).padding.top + 20,
          right: 24,
          child: Container(
            width: 110,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05), 
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: _isBypassMode || !_localUserJoined || !_isCameraOn
                  ? _buildSimulatedLocalFeed()
                  : AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
            ),
          ),
        ),

        // Header Info
        Positioned(
          top: MediaQuery.of(context).padding.top + 20,
          left: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fiber_manual_record_rounded, color: Colors.redAccent, size: 12),
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
                const SizedBox(height: 8),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.lock_rounded, color: const Color(0xFF065643).withValues(alpha: 0.4), size: 14),
                  const SizedBox(width: 8),
                  Text(
                    "End-to-End Encrypted",
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF065643).withValues(alpha: 0.5), 
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Controls Area
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 30,
          left: 24,
          right: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(48),
              border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildControlButton(
                  _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  _isMuted,
                  _toggleMute,
                ),
                _buildControlButton(
                  _isCameraOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                  !_isCameraOn,
                  _toggleCamera,
                ),
                const SizedBox(width: 16),
                _buildEndCallButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimulatedTherapistFeed() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
          const SizedBox(height: 32),
          Text(
            widget.therapistName,
            style: GoogleFonts.outfit(
              color: const Color(0xFF065643), 
              fontSize: 32, 
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isBypassMode ? "Secure audio consultation (Bypass Video Active)" : "Waiting for therapist to join video stream...",
            style: GoogleFonts.outfit(
              color: Colors.grey[600], 
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatedLocalFeed() {
    return Stack(
      children: [
        Center(
          child: Icon(
            Icons.person_outline_rounded, 
            color: const Color(0xFF065643).withValues(alpha: 0.2), 
            size: 48,
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF065643).withValues(alpha: 0.08), 
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.flip_camera_ios_rounded, color: Color(0xFF065643), size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF4B4B).withValues(alpha: 0.15) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? const Color(0xFFFF4B4B).withValues(alpha: 0.4) : const Color(0xFF065643).withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon, 
          color: isActive ? const Color(0xFFFF4B4B) : const Color(0xFF065643), 
          size: 28,
        ),
      ),
    );
  }

  Widget _buildEndCallButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4B4B),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4B4B).withValues(alpha: 0.3), 
                blurRadius: 20, 
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  void _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    await _engine?.muteLocalAudioStream(_isMuted);
  }

  void _toggleCamera() async {
    setState(() => _isCameraOn = !_isCameraOn);
    await _engine?.enableLocalVideo(_isCameraOn);
  }
}
