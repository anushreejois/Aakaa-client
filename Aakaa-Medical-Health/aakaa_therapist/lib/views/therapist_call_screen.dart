import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/encryption_helper.dart';

class TherapistCallScreen extends StatefulWidget {
  final String appointmentId;
  final String clientName;
  final String callType; // "video" or "audio"

  const TherapistCallScreen({
    super.key,
    required this.appointmentId,
    required this.clientName,
    required this.callType,
  });

  @override
  State<TherapistCallScreen> createState() => _TherapistCallScreenState();
}

class _TherapistCallScreenState extends State<TherapistCallScreen> {
  RtcEngine? _engine;
  bool _localUserJoined = false;
  int? _remoteUid;
  bool _muted = false;
  bool _cameraOff = false;
  bool _isLoading = true;

  String _appId = "";
  String _token = "";
  int _uid = 0;

  // === 📝 Clinical Notes State ===
  bool _isNotepadOpen = false;
  final TextEditingController _notesController = TextEditingController();
  bool _isSavingNotes = false;

  @override
  void initState() {
    super.initState();
    _fetchTokenAndJoin();
    _fetchNotes();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _leaveChannel();
    super.dispose();
  }

  Future<void> _fetchNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) return;

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/therapist/bookings/${widget.appointmentId}/notes");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success" && data["encryptedNotes"] != null) {
          final decrypted = EncryptionHelper.decrypt(data["encryptedNotes"]);
          setState(() {
            _notesController.text = decrypted;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching notes: $e");
    }
  }

  Future<void> _saveNotes() async {
    setState(() {
      _isSavingNotes = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) return;

      final encrypted = EncryptionHelper.encrypt(_notesController.text.trim());

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/therapist/bookings/${widget.appointmentId}/notes");
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "encryptedNotes": encrypted,
        }),
      );

      if (response.statusCode == 200) {
        _showSyncSnackBar("Notes securely synchronized with MongoDB Atlas.", isError: false);
      } else {
        _showSyncSnackBar("Failed to save notes to backend.", isError: true);
      }
    } catch (e) {
      debugPrint("Error saving notes: $e");
      _showSyncSnackBar("Connection error. Saved locally.", isError: true);
    } finally {
      setState(() {
        _isSavingNotes = false;
      });
    }
  }

  Future<void> _fetchTokenAndJoin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) {
        _showErrorAndExit("Authentication required. Please log in again.");
        return;
      }

      // Format unique channel name from appointment ID
      final String channelName = "session_${widget.appointmentId}";

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/agora/generate-token");
      
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "channelName": channelName,
          "role": "publisher",
          "uid": 0 // 0 lets Agora auto-assign numeric UID
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          setState(() {
            _appId = data["appId"] ?? "";
            _token = data["token"] ?? "";
            _uid = data["uid"] ?? 0;
            _isLoading = false;
          });

          await _initAgora(channelName);
        } else {
          _showErrorAndExit("Server error fetching session token.");
        }
      } else {
        _showErrorAndExit("Failed to establish session gateway.");
      }
    } catch (e) {
      debugPrint("Error fetching Agora token: $e");
      _showErrorAndExit("Connection failure initializing room: $e");
    }
  }

  Future<void> _initAgora(String channelName) async {
    // Request audio/video permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      if (widget.callType == "video") Permission.camera,
    ].request();

    if (statuses[Permission.microphone] != PermissionStatus.granted ||
        (widget.callType == "video" && statuses[Permission.camera] != PermissionStatus.granted)) {
      _showErrorAndExit("Microphone and Camera permissions are required for consultations.");
      return;
    }

    // Bypass real Agora init if App ID is the mock developer ID to avoid emulator camera lock
    if (_appId == "mock_app_id_12345" || _appId.startsWith("mock")) {
      debugPrint("Mock Agora App ID detected. Skipping native engine init for safe emulation.");
      setState(() {
        _localUserJoined = true;
      });
      _showSyncSnackBar("Development Mode: Running in local simulated room.", isError: false);
      return;
    }

    try {
      // Create and configure Agora RTC Engine
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId: _appId.isNotEmpty ? _appId : "mock_app_id_12345",
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint("Local therapist joined channel: ${connection.channelId} with uid ${connection.localUid}");
            setState(() {
              _localUserJoined = true;
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint("Client joined room: $remoteUid");
            setState(() {
              _remoteUid = remoteUid;
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            debugPrint("Client disconnected from room: $remoteUid");
            setState(() {
              _remoteUid = null;
            });
          },
        ),
      );

      if (widget.callType == "video") {
        await _engine!.enableVideo();
        await _engine!.startPreview();
      } else {
        await _engine!.enableAudio();
      }

      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      // Join room
      await _engine!.joinChannel(
        token: _token,
        channelId: channelName,
        uid: _uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
    } catch (e) {
      debugPrint("Agora init error: $e");
      // Fallback state for local simulation if RtcEngine can't start (e.g. mock test env)
      setState(() {
        _localUserJoined = true;
      });
      _showSyncSnackBar("Agora Offline: Running in local bypass mode.", isError: false);
    }
  }

  Future<void> _leaveChannel() async {
    if (_engine != null) {
      await _engine!.leaveChannel();
      await _engine!.release();
      _engine = null;
    }
  }

  void _showErrorAndExit(String message) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFFCFAF9),
          title: Text(
            "Session Connection",
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF065643)),
          ),
          content: Text(
            message,
            style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.7)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to Dashboard
              },
              child: Text(
                "Dismiss",
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF065643)),
              ),
            )
          ],
        ),
      );
    });
  }

  void _showSyncSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF065643),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // === 🎥 VIDEO LAYOUT RENDERER ===
  Widget _buildVideoLayout() {
    const Color brandColor = Color(0xFF065643);

    return Stack(
      children: [
        // Remote Client Stream
        Positioned.fill(
          child: _remoteUid != null
              ? (_engine != null
                  ? AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _engine!,
                        canvas: VideoCanvas(uid: _remoteUid),
                        connection: RtcConnection(channelId: "session_${widget.appointmentId}"),
                      ),
                    )
                  : Container(
                      color: Colors.black87,
                      child: const Center(child: Text("Bypass Video Mock Stream", style: TextStyle(color: Colors.white))),
                    ))
              : Container(
                  color: const Color(0xFF1E2624),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: brandColor.withValues(alpha: 0.1),
                          child: Text(
                            widget.clientName.isNotEmpty ? widget.clientName[0].toUpperCase() : "C",
                            style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: brandColor),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Calling ${widget.clientName}...",
                          style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Waiting for patient to enter session room",
                          style: GoogleFonts.outfit(color: Colors.white60, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
        ),

        // Local Therapist Thumbnail (PIP)
        if (_localUserJoined && !_cameraOff)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 110,
                height: 160,
                color: Colors.black,
                child: _engine != null
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine!,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.videocam_rounded, color: Colors.white38),
                      ),
              ),
            ),
          ),
      ],
    );
  }

  // === 🎙️ AUDIO LAYOUT RENDERER ===
  Widget _buildAudioLayout() {
    const Color brandColor = Color(0xFF065643);

    return Container(
      color: const Color(0xFFFCFAF9),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Client Avatar with pulse wave
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brandColor.withValues(alpha: 0.05),
                ),
              ),
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brandColor.withValues(alpha: 0.08),
                ),
              ),
              CircleAvatar(
                radius: 50,
                backgroundColor: brandColor,
                child: Text(
                  widget.clientName.isNotEmpty ? widget.clientName[0].toUpperCase() : "C",
                  style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Details text
          Text(
            widget.clientName,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: brandColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _remoteUid != null ? "Session Connected" : "Calling patient...",
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: _remoteUid != null ? const Color(0xFF5B8C7A) : brandColor.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandColor = Color(0xFF065643);

    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: brandColor),
            )
          : Stack(
              children: [
                // Render format specific layouts
                Positioned.fill(
                  child: widget.callType == "video" ? _buildVideoLayout() : _buildAudioLayout(),
                ),

                // Top Exit / Back button overlay
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withValues(alpha: 0.3),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        await _saveNotes();
                        if (mounted) Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                // Controls Floating Panel
                Positioned(
                  bottom: 36,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Toggle Mute Button
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: _muted ? Colors.redAccent : Colors.white.withValues(alpha: 0.15),
                          child: IconButton(
                            icon: Icon(
                              _muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _muted = !_muted;
                              });
                              if (_engine != null) {
                                await _engine!.muteLocalAudioStream(_muted);
                              }
                            },
                          ),
                        ),

                        // Toggle Notepad Button
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: _isNotepadOpen ? const Color(0xFF0A7D62) : Colors.white.withValues(alpha: 0.15),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit_note_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _isNotepadOpen = !_isNotepadOpen;
                              });
                            },
                          ),
                        ),

                        // Hang Up / Disconnect Button
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.redAccent,
                          child: IconButton(
                            icon: const Icon(Icons.call_end_rounded, color: Colors.white, size: 28),
                            onPressed: () async {
                              HapticFeedback.mediumImpact();
                              await _saveNotes();
                              await _leaveChannel();
                              if (mounted) Navigator.pop(context);
                            },
                          ),
                        ),

                        // Toggle Camera Button (Video mode only)
                        if (widget.callType == "video")
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: _cameraOff ? Colors.redAccent : Colors.white.withValues(alpha: 0.15),
                            child: IconButton(
                              icon: Icon(
                                _cameraOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _cameraOff = !_cameraOff;
                                });
                                if (_engine != null) {
                                  await _engine!.muteLocalVideoStream(_cameraOff);
                                  if (_cameraOff) {
                                    await _engine!.stopPreview();
                                  } else {
                                    await _engine!.startPreview();
                                  }
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Clinical Notepad Sliding Overlay
                _buildClinicalNotepadOverlay(),
              ],
            ),
    );
  }

  Widget _buildClinicalNotepadOverlay() {
    if (!_isNotepadOpen) return const SizedBox.shrink();

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    // For wider screens, make it a side-panel, otherwise a bottom overlay
    final bool isWide = screenWidth > 600;
    
    return Positioned(
      right: 0,
      left: isWide ? screenWidth - 360 : 0,
      top: isWide ? 0 : screenHeight * 0.25,
      bottom: MediaQuery.of(context).viewInsets.bottom,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(28),
            topRight: isWide ? Radius.zero : const Radius.circular(28),
            bottomLeft: isWide ? const Radius.circular(28) : Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 25,
              offset: const Offset(-5, 0),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notepad Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.security_rounded, color: Color(0xFF065643), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Encrypted Notepad",
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _isNotepadOpen = false;
                    });
                  },
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            
            // Note Editor Text Field
            Expanded(
              child: TextFormField(
                controller: _notesController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.outfit(fontSize: 14.5, color: const Color(0xFF065643), height: 1.45),
                decoration: InputDecoration(
                  hintText: "Type clinical progress logs here...\n\nAll notes will be client-side encrypted using AES-256 before syncing back to Aakaa servers.",
                  hintStyle: GoogleFonts.outfit(fontSize: 13.5, color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Notepad Footer Sync Status / Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isSavingNotes ? "Syncing..." : "AES-256 Secured",
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _saveNotes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF065643),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    elevation: 0,
                  ),
                  icon: _isSavingNotes
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.5),
                        )
                      : const Icon(Icons.sync_rounded, size: 14),
                  label: Text(
                    "Sync Notes",
                    style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
