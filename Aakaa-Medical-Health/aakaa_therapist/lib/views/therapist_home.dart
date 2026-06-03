import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/zen_background.dart';
import 'therapist_login.dart';
import 'therapist_chat_hub.dart';
import 'therapist_call_screen.dart';

class TherapistHome extends StatefulWidget {
  final String doctorName;
  const TherapistHome({super.key, required this.doctorName});

  @override
  State<TherapistHome> createState() => _TherapistHomeState();
}

class _TherapistHomeState extends State<TherapistHome> {
  int _currentTab = 0;
  bool _isOnline = true; // Global availability toggle
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _refreshTimer;

  // === 🔔 Notification State Variables ===
  List<dynamic> _notifications = [];
  bool _isLoadingNotifications = false;
  int _unreadNotificationCount = 0;

  // === 📅 Tab 1: Availability State Variables ===
  int _sessionDurationMinutes = 45; // 30, 45, 60
  final List<String> _activeDays = ["Mon", "Wed", "Fri"];
  final List<Map<String, String>> _timeSlots = [
    {"start": "09:00 AM", "end": "12:00 PM"},
    {"start": "03:00 PM", "end": "06:00 PM"}
  ];

  // === ⚙️ Tab 3: Clinical Profile State Variables ===
  bool _isLoadingProfile = false;
  bool _isEditMode = false;
  
  // Profile Form Controllers
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _specialtiesController = TextEditingController();
  final _videoRateController = TextEditingController();
  final _audioRateController = TextEditingController();
  final _chatRateController = TextEditingController();
  final _avatarUrlController = TextEditingController();

  List<String> _profileSpecialties = [];
  String _profileLicenseNumber = "";
  String _profileBio = "";
  String _profileAvatarUrl = "";
  int _videoRate = 1500;
  int _audioRate = 1000;
  int _chatRate = 600;

  // === 💬 Tab 0: Booking Requests Inbox (Live API State) ===
  List<dynamic> _realBookings = [];
  bool _isLoadingBookings = false;

  List<dynamic> get _pendingBookings =>
      _realBookings.where((b) => b["status"] == "pending").toList();

  List<dynamic> get _approvedBookings =>
      _realBookings.where((b) => b["status"] == "approved").toList();

  @override
  void initState() {
    super.initState();
    _fetchBookings();
    _fetchProfile();
    _fetchNotifications();
    _fetchEarnings();

    // Start periodic background updates every 12 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 12), (timer) {
      if (mounted) {
        _fetchBookings();
        _fetchNotifications();
        _fetchEarnings();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _nameController.dispose();
    _bioController.dispose();
    _specialtiesController.dispose();
    _videoRateController.dispose();
    _audioRateController.dispose();
    _chatRateController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoadingProfile = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) return;

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/therapist/profile");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success" && data["therapist"] != null) {
          final t = data["therapist"];
          final user = t["userId"];
          
          setState(() {
            _profileLicenseNumber = t["licenseNumber"] ?? "";
            _profileBio = t["bio"] ?? "";
            _profileSpecialties = List<String>.from(t["specialties"] ?? []);
            _videoRate = (t["videoRate"] as num?)?.toInt() ?? 1500;
            _audioRate = (t["audioRate"] as num?)?.toInt() ?? 1000;
            _chatRate = (t["chatRate"] as num?)?.toInt() ?? 600;
            _sessionDurationMinutes = (t["sessionDuration"] as num?)?.toInt() ?? 45;
            
            if (t["activeDays"] != null) {
              _activeDays.clear();
              for (var day in t["activeDays"]) {
                if (day != null) {
                  _activeDays.add(day.toString());
                }
              }
            }
            if (t["timeSlots"] != null) {
              _timeSlots.clear();
              for (var slot in t["timeSlots"]) {
                if (slot != null && slot is Map) {
                  _timeSlots.add({
                    "start": slot["start"]?.toString() ?? "",
                    "end": slot["end"]?.toString() ?? "",
                  });
                }
              }
            }

            // Seed form controllers
            if (user != null) {
              _nameController.text = user["fullName"] ?? widget.doctorName;
              _profileAvatarUrl = user["avatarUrl"] ?? "";
              _avatarUrlController.text = _profileAvatarUrl;
            } else {
              _nameController.text = widget.doctorName;
              _profileAvatarUrl = "";
              _avatarUrlController.text = "";
            }
            _bioController.text = _profileBio;
            _specialtiesController.text = _profileSpecialties.join(", ");
            _videoRateController.text = _videoRate.toString();
            _audioRateController.text = _audioRate.toString();
            _chatRateController.text = _chatRate.toString();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    HapticFeedback.mediumImpact();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF065643)),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) {
        if (mounted) Navigator.pop(context);
        return;
      }

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/therapist/profile");
      
      final parsedSpecialties = _specialtiesController.text
          .split(",")
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "fullName": _nameController.text.trim(),
          "avatarUrl": _avatarUrlController.text.trim(),
          "bio": _bioController.text.trim(),
          "specialties": parsedSpecialties,
          "videoRate": int.tryParse(_videoRateController.text) ?? _videoRate,
          "audioRate": int.tryParse(_audioRateController.text) ?? _audioRate,
          "chatRate": int.tryParse(_chatRateController.text) ?? _chatRate,
        }),
      );

      if (mounted) Navigator.pop(context); // Close loading indicator

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success" && data["therapist"] != null) {
          final t = data["therapist"];
          final user = t["userId"];
          
          setState(() {
            _profileBio = t["bio"] ?? "";
            _profileSpecialties = List<String>.from(t["specialties"] ?? []);
            _videoRate = (t["videoRate"] as num?)?.toInt() ?? 1500;
            _audioRate = (t["audioRate"] as num?)?.toInt() ?? 1000;
            _chatRate = (t["chatRate"] as num?)?.toInt() ?? 600;
            if (user != null) {
              _profileAvatarUrl = user["avatarUrl"] ?? "";
              _nameController.text = user["fullName"] ?? widget.doctorName;
              _avatarUrlController.text = _profileAvatarUrl;
            }
            _isEditMode = false;
          });

          _showSyncSnackBar("Clinical profile updated successfully!", isError: false);
        }
      } else {
        _showSyncSnackBar("Failed to save profile. Try again.", isError: true);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSyncSnackBar("Connection error. Update failed.", isError: true);
    }
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoadingBookings = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) return;

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/therapist/bookings");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          setState(() {
            _realBookings = data["bookings"] ?? [];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching bookings: $e");
    } finally {
      setState(() {
        _isLoadingBookings = false;
      });
    }
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoadingNotifications = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) return;

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/notifications");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          final List<dynamic> fetched = data["notifications"] ?? [];
          setState(() {
            _notifications = fetched;
            _unreadNotificationCount = fetched.where((n) => n["read"] == false).length;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    } finally {
      setState(() {
        _isLoadingNotifications = false;
      });
    }
  }

  Future<void> _markAllNotificationsAsRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) return;

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/notifications/read-all");
      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          for (var n in _notifications) {
            n["read"] = true;
          }
          _unreadNotificationCount = 0;
        });
        _showSyncSnackBar("All notifications marked as read", isError: false);
      }
    } catch (e) {
      debugPrint("Error marking all notifications as read: $e");
    }
  }

  Future<void> _markNotificationAsRead(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) return;

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/notifications/$id/read");
      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          final idx = _notifications.indexWhere((n) => n["_id"] == id);
          if (idx != -1) {
            _notifications[idx]["read"] = true;
          }
          _unreadNotificationCount = _notifications.where((n) => n["read"] == false).length;
        });
      }
    } catch (e) {
      debugPrint("Error marking notification as read: $e");
    }
  }

  // === 💼 Tab 2: Earnings Ledger Live Data ===
  List<dynamic> _earningsLedger = [];
  int _totalGross = 0;
  int _totalCommission = 0;
  int _totalNet = 0;
  int _pendingPayout = 0;
  int _settledPayout = 0;
  bool _isLoadingEarnings = false;

  Future<void> _fetchEarnings() async {
    setState(() {
      _isLoadingEarnings = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) return;

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/therapist/earnings");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          setState(() {
            _totalGross = (data["totalGross"] as num?)?.toInt() ?? 0;
            _totalCommission = (data["totalCommission"] as num?)?.toInt() ?? 0;
            _totalNet = (data["totalNet"] as num?)?.toInt() ?? 0;
            _pendingPayout = (data["pendingPayout"] as num?)?.toInt() ?? 0;
            _settledPayout = (data["settledPayout"] as num?)?.toInt() ?? 0;
            _earningsLedger = data["ledger"] ?? [];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching earnings: $e");
    } finally {
      setState(() {
        _isLoadingEarnings = false;
      });
    }
  }

  Future<void> _handleRequestAction(String bookingId, String action) async {
    HapticFeedback.mediumImpact();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF065643)),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) {
        if (mounted) Navigator.pop(context);
        return;
      }

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/therapist/bookings/$bookingId");
      
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "status": action,
        }),
      );

      if (mounted) Navigator.pop(context); // Close loading dialog

      if (response.statusCode == 200) {
        _fetchBookings();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Appointment successfully $action.",
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
              backgroundColor: action == "approved" ? const Color(0xFF065643) : Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to update appointment.", style: GoogleFonts.outfit()),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Network error. Action failed.", style: GoogleFonts.outfit()),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleLogout() {
    HapticFeedback.heavyImpact();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const TherapistLogin()),
      (route) => false,
    );
  }

  // === 📅 Availability Creator Logic ===
  void _addNewTimeSlot() async {
    HapticFeedback.lightImpact();
    final TimeOfDay? start = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      helpText: "SELECT START TIME",
    );
    if (start == null) return;

    if (!mounted) return;

    final TimeOfDay? end = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: start.hour + 3, minute: start.minute),
      helpText: "SELECT END TIME",
    );
    if (end == null) return;

    if (!mounted) return;

    setState(() {
      _timeSlots.add({
        "start": start.format(context),
        "end": end.format(context),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("New availability interval added.", style: GoogleFonts.outfit()),
        backgroundColor: const Color(0xFF065643),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeTimeSlot(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _timeSlots.removeAt(index);
    });
  }

  void _saveAvailability() async {
    HapticFeedback.mediumImpact();
    
    // Stash loading indicators
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF065643)),
      ),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null || token.isEmpty) {
        if (mounted) Navigator.pop(context); // Close loading dialogue
        _showSyncSnackBar("Auth token missing. Please log in again.", isError: true);
        return;
      }

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/therapist/availability");

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "sessionDuration": _sessionDurationMinutes,
          "activeDays": _activeDays,
          "timeSlots": _timeSlots
        }),
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialogue

      if (response.statusCode == 200) {
        _showSyncSnackBar("Availability schedule synced with MongoDB successfully!", isError: false);
      } else {
        _showSyncSnackBar("Failed to sync schedule. Please try again.", isError: true);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialogue
      _showSyncSnackBar("Connection error. Sync failed.", isError: true);
    }
  }

  void _showSyncSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF065643),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildNotificationDrawer(),
      body: ZenBackground(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // 🏠 Main Content Switcher
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildCurrentTabContent(),
                ),
              ),

              // 🌟 Bottom Navigation Bar
              _buildBottomNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }

  // === 🌟 HEADER WIDGET ===
  Widget _buildHeaderBar() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: statusBarHeight + 12.0,
        bottom: 8.0,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 48,
              height: 48,
              color: const Color(0xFF065643).withValues(alpha: 0.1),
              child: _profileAvatarUrl.isNotEmpty
                  ? Image.network(
                      _profileAvatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          widget.doctorName.isNotEmpty ? widget.doctorName.replaceAll("Dr. ", "")[0].toUpperCase() : "D",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF065643),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        widget.doctorName.isNotEmpty ? widget.doctorName.replaceAll("Dr. ", "")[0].toUpperCase() : "D",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getHeaderSubtitle(),
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: const Color(0xFF065643).withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _getHeaderTitle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065643),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_rounded, color: Color(0xFF065643)),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
              if (_unreadNotificationCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFC8826B), // Beautiful Calming Terracotta Coral
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_unreadNotificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.message_rounded, color: Color(0xFF065643)),
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TherapistChatHub()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF065643)),
            onPressed: _handleLogout,
          ),
        ],
      ),
    );
  }

  // === 🔔 SLIDING NOTIFICATION DRAWER ===
  Widget _buildNotificationDrawer() {
    const Color brandColor = Color(0xFF065643);
    const Color warmDaylightBg = Color(0xFFFCFAF9);

    return Drawer(
      backgroundColor: warmDaylightBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Alert Center",
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: brandColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$_unreadNotificationCount unread alerts",
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: brandColor.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (_notifications.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _markAllNotificationsAsRead();
                      },
                      child: Text(
                        "Clear All",
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: brandColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Notification List
            Expanded(
              child: _isLoadingNotifications && _notifications.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(color: brandColor),
                    )
                  : _notifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none_rounded,
                                size: 64,
                                color: brandColor.withValues(alpha: 0.15),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "All Caught Up!",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: brandColor.withValues(alpha: 0.5),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "No new clinical alerts at the moment.",
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  color: brandColor.withValues(alpha: 0.4),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _notifications.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final alert = _notifications[index];
                            final String alertId = alert["_id"] ?? "";
                            final bool isRead = alert["read"] ?? false;
                            final String title = alert["title"] ?? "Alert";
                            final String message = alert["message"] ?? "";
                            final String type = alert["type"] ?? "system";
                            final String timeStr = alert["createdAt"] != null
                                ? DateTime.tryParse(alert["createdAt"])?.toLocal().toString().substring(11, 16) ?? ""
                                : "";

                            IconData iconData = Icons.info_outline_rounded;
                            Color iconColor = brandColor;
                            if (type == 'booking_request') {
                              iconData = Icons.calendar_today_rounded;
                              iconColor = const Color(0xFFC8826B); // Soft terracotta
                            } else if (type == 'booking_status') {
                              iconData = Icons.check_circle_outline_rounded;
                              iconColor = brandColor;
                            } else if (type == 'chat_message') {
                              iconData = Icons.forum_rounded;
                              iconColor = const Color(0xFF5B8C7A); // Calming mint
                            }

                            return InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                if (!isRead) {
                                  _markNotificationAsRead(alertId);
                                }
                                Navigator.pop(context); // Close Drawer
                                
                                // Perform custom action based on type
                                if (type == 'booking_request' || type == 'booking_status') {
                                  setState(() {
                                    _currentTab = 0; // Switch to dashboard tab
                                  });
                                } else if (type == 'chat_message') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const TherapistChatHub()),
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isRead ? Colors.white.withValues(alpha: 0.6) : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isRead
                                        ? brandColor.withValues(alpha: 0.05)
                                        : brandColor.withValues(alpha: 0.15),
                                    width: isRead ? 1.0 : 1.5,
                                  ),
                                  boxShadow: isRead
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: brandColor.withValues(alpha: 0.03),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          )
                                        ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: iconColor.withValues(alpha: 0.1),
                                      child: Icon(iconData, size: 20, color: iconColor),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  title,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 14.5,
                                                    fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                                                    color: brandColor,
                                                  ),
                                                ),
                                              ),
                                              if (timeStr.isNotEmpty)
                                                Text(
                                                  timeStr,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 11,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            message,
                                            style: GoogleFonts.outfit(
                                              fontSize: 13,
                                              color: brandColor.withValues(alpha: isRead ? 0.5 : 0.75),
                                              height: 1.35,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentTab) {
      case 0:
        return widget.doctorName;
      case 1:
        return "Schedule Manager";
      case 2:
        return "Earnings Ledger";
      case 3:
        return "Professional Profile";
      default:
        return widget.doctorName;
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentTab) {
      case 0:
        return "Welcome back,";
      case 1:
        return "Availability Matrix";
      case 2:
        return "Revenue & Splits";
      case 3:
        return "Credential Center";
      default:
        return "Caregiver Portal";
    }
  }

  // === 🏠 PAGE SELECTOR SWITCH ===
  Widget _buildCurrentTabContent() {
    switch (_currentTab) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildAvailabilityTab();
      case 2:
        return _buildEarningsTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildDashboardTab();
    }
  }

  // ==========================================
  // TAB 0: DASHBOARD SUB-SCREEN
  // ==========================================
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvailabilityCard(),
                const SizedBox(height: 20),
                _buildNextSessionHUD(),
                const SizedBox(height: 20),
                _buildStatsGrid(),
                const SizedBox(height: 24),
                Text(
                  "Booking Request Inbox (${_pendingBookings.length})",
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065643),
                  ),
                ),
                const SizedBox(height: 12),
                _isLoadingBookings
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: CircularProgressIndicator(color: Color(0xFF065643)),
                        ),
                      )
                    : _pendingBookings.isEmpty
                        ? _buildEmptyInbox()
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _pendingBookings.length,
                            separatorBuilder: (_, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final req = _pendingBookings[index];
                              return _buildBookingCard(req, index);
                            },
                          ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: AVAILABILITY MATRIX SUB-SCREEN
  // ==========================================
  Widget _buildAvailabilityTab() {
    final List<String> weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🌟 1. Session Duration Picker
            Text(
              "Default Session Duration",
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF065643),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Includes automated 10-minute buffer buffer spacing",
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: const Color(0xFF065643).withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [30, 45, 60].map((minutes) {
                final isSelected = _sessionDurationMinutes == minutes;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _sessionDurationMinutes = minutes;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF065643) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF065643) : const Color(0xFF065643).withValues(alpha: 0.08),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "$minutes Mins",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : const Color(0xFF065643),
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // 🌟 2. Weekly Day selector Matrix
            Text(
              "Active Practice Days",
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF065643),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((day) {
                final isSelected = _activeDays.contains(day);
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      if (isSelected) {
                        _activeDays.remove(day);
                      } else {
                        _activeDays.add(day);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF065643) : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF065643) : const Color(0xFF065643).withValues(alpha: 0.08),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      day[0],
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF065643),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // 🌟 3. Daily Interval Slots list
            Row(
              children: [
                Text(
                  "Daily Availability Slots",
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065643),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                  label: Text("Add Slot", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF065643)),
                  onPressed: _addNewTimeSlot,
                ),
              ],
            ),
            const SizedBox(height: 8),

            _timeSlots.isEmpty
                ? _buildEmptySlots()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _timeSlots.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final slot = _timeSlots[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF065643).withValues(alpha: 0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: Color(0xFF065643), size: 20),
                            const SizedBox(width: 14),
                            Text(
                              "${slot["start"]} - ${slot["end"]}",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: const Color(0xFF065643),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                              onPressed: () => _removeTimeSlot(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 36),

            // 🌟 4. Save Button
            SizedBox(
              width: double.infinity,
              height: 65,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF065643).withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _saveAvailability,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    "Sync Schedule",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ],
  ),
);
}
  // ==========================================
  // TAB 2: EARNINGS WALLET SUB-SCREEN
  Widget _buildEarningsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🌟 Wallet Balance card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF065643),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF065643).withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PENDING PAYOUT",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "₹$_pendingPayout",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white12,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "SETTLED PAYOUT",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "₹$_settledPayout",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Automatic payouts occur 48 hours post consult confirmation.",
                        style: GoogleFonts.outfit(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: Colors.white12, height: 1),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFinMetric("Gross Revenue", "₹$_totalGross"),
                          _buildFinMetric("Aakaa Comm (20%)", "₹$_totalCommission"),
                          _buildFinMetric("Payout Net Share", "₹$_totalNet"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  "Completed Session History",
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065643),
                  ),
                ),
                const SizedBox(height: 12),

                _isLoadingEarnings && _earningsLedger.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: CircularProgressIndicator(color: Color(0xFF065643)),
                        ),
                      )
                    : _earningsLedger.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 48.0),
                              child: Column(
                                children: [
                                  Icon(Icons.history_toggle_off_rounded, size: 48, color: const Color(0xFF065643).withValues(alpha: 0.2)),
                                  const SizedBox(height: 12),
                                  Text(
                                    "No completed transactions yet",
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.5,
                                      color: const Color(0xFF065643).withValues(alpha: 0.4),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Completed sessions will list here dynamically.",
                                    style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _earningsLedger.length,
                            separatorBuilder: (_, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = _earningsLedger[index];
                              final clientName = item["clientName"] ?? "Client";
                              final type = item["type"] ?? "Session Call";
                              final dateStr = item["date"] ?? "";
                              final net = item["net"] ?? 0;
                              final gross = item["gross"] ?? 0;
                              final comm = item["commission"] ?? 0;
                              final status = item["status"] ?? "Settled";

                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: const Color(0xFF065643).withValues(alpha: 0.08),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF065643).withValues(alpha: 0.05),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            type.toString().contains("Video")
                                                ? Icons.videocam_rounded
                                                : type.toString().contains("Audio")
                                                    ? Icons.phone_callback_rounded
                                                    : Icons.forum_rounded,
                                            color: const Color(0xFF065643),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      clientName,
                                                      style: GoogleFonts.outfit(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: const Color(0xFF065643),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: status.toString().contains("Pending")
                                                          ? const Color(0xFFC8826B).withValues(alpha: 0.1)
                                                          : const Color(0xFF065643).withValues(alpha: 0.08),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      status,
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold,
                                                        color: status.toString().contains("Pending")
                                                            ? const Color(0xFFC8826B)
                                                            : const Color(0xFF065643),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "$type • $dateStr",
                                                style: GoogleFonts.outfit(
                                                  fontSize: 11.5,
                                                  color: const Color(0xFF065643).withValues(alpha: 0.4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          "+₹$net",
                                          style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: const Color(0xFF065643),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    const Divider(color: Color(0xFFFFF7F5), height: 1),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildLedgerBreakdown("Gross Charge", "₹$gross"),
                                        _buildLedgerBreakdown("Comm (20%)", "-₹$comm"),
                                        _buildLedgerBreakdown("Net Payout", "₹$net", highlight: true),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLedgerBreakdown(String label, String value, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: highlight ? const Color(0xFF065643) : Colors.black87,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 3: CLINICAL PROFILE SUB-SCREEN
  // ==========================================
  Widget _buildProfileTab() {
    const Color brandColor = Color(0xFF065643);
    
    if (_isLoadingProfile) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.0),
          child: CircularProgressIndicator(color: brandColor),
        ),
      );
    }

    final String displayName = _nameController.text.isNotEmpty ? _nameController.text : widget.doctorName;
    final String initialChar = displayName.replaceAll("Dr. ", "").isNotEmpty 
        ? displayName.replaceAll("Dr. ", "")[0].toUpperCase() 
        : "D";

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                // 🌟 Avatar profile card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: brandColor.withValues(alpha: 0.08)),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: brandColor.withValues(alpha: 0.1),
                          child: _profileAvatarUrl.isNotEmpty
                              ? Image.network(
                                  _profileAvatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Center(
                                    child: Text(
                                      initialChar,
                                      style: GoogleFonts.outfit(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: brandColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    initialChar,
                                    style: GoogleFonts.outfit(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: brandColor,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        displayName,
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: brandColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.verified_rounded, color: brandColor, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "HIPAA & Medical License Verified",
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: brandColor,
                            ),
                          ),
                        ],
                      ),
                      if (_profileLicenseNumber.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          "License # $_profileLicenseNumber",
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: brandColor.withValues(alpha: 0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (!_isEditMode) ...[
                  // 🌟 STATIC VIEW
                  // Biography
                  _buildProfileSection(
                    title: "Professional Biography",
                    child: Text(
                      _profileBio.isNotEmpty 
                          ? _profileBio 
                          : "Licensed clinical professional dedicated to patient support.",
                      style: GoogleFonts.outfit(
                        fontSize: 13.5,
                        color: brandColor.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Specialties
                  _buildProfileSection(
                    title: "Active Specialties",
                    child: _profileSpecialties.isEmpty
                        ? Text(
                            "No specialties configured.",
                            style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _profileSpecialties.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: brandColor.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.5,
                                    color: brandColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Rates
                  _buildProfileSection(
                    title: "Consultation Pricing Structures",
                    child: Column(
                      children: [
                        _buildRateRow(Icons.videocam_rounded, "Video Consultation (45m)", "₹$_videoRate"),
                        const SizedBox(height: 12),
                        _buildRateRow(Icons.phone_callback_rounded, "Audio Consultation (45m)", "₹$_audioRate"),
                        const SizedBox(height: 12),
                        _buildRateRow(Icons.chat_bubble_outline_rounded, "Direct Text Messaging (Daily)", "₹$_chatRate"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Edit Mode Switcher Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _isEditMode = true;
                        });
                      },
                      icon: const Icon(Icons.edit_rounded),
                      label: Text(
                        "Edit Clinical Profile",
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: brandColor,
                        side: BorderSide(color: brandColor.withValues(alpha: 0.15), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                    ),
                  ),
                ] else ...[
                  // 📝 EDIT MODE FIELDS FORM
                  _buildProfileSection(
                    title: "Edit Professional Details",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEditField("Caregiver Full Name", _nameController),
                        const SizedBox(height: 16),
                        _buildEditField("Profile Picture URL", _avatarUrlController),
                        const SizedBox(height: 10),
                        Text(
                          "Curated Avatar Presets:",
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: brandColor.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _buildAvatarPresetChip(
                                "Female Caregiver 1",
                                "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&h=400&fit=crop",
                              ),
                              const SizedBox(width: 8),
                              _buildAvatarPresetChip(
                                "Male Caregiver 2",
                                "https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&h=400&fit=crop",
                              ),
                              const SizedBox(width: 8),
                              _buildAvatarPresetChip(
                                "Calm Nature Theme",
                                "https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=400&h=400&fit=crop",
                              ),
                              const SizedBox(width: 8),
                              _buildAvatarPresetChip(
                                "Therapeutic Sunset",
                                "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&h=400&fit=crop",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildEditField("Professional Biography", _bioController, maxLines: 4),
                        const SizedBox(height: 16),
                        _buildEditField("Clinical Specialties (comma-separated)", _specialtiesController),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildEditField("Video Fee (₹)", _videoRateController, keyboardType: TextInputType.number)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildEditField("Audio Fee (₹)", _audioRateController, keyboardType: TextInputType.number)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildEditField("Daily Chat Fee (₹)", _chatRateController, keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _isEditMode = false;
                              // Reset controllers
                              _nameController.text = displayName;
                              _avatarUrlController.text = _profileAvatarUrl;
                              _bioController.text = _profileBio;
                              _specialtiesController.text = _profileSpecialties.join(", ");
                              _videoRateController.text = _videoRate.toString();
                              _audioRateController.text = _audioRate.toString();
                              _chatRateController.text = _chatRate.toString();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: Text(
                            "Save Profile",
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    const Color brandColor = Color(0xFF065643);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: brandColor.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.outfit(fontSize: 14.5),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFCFAF9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: brandColor.withValues(alpha: 0.1), width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: brandColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarPresetChip(String tooltip, String url) {
    const Color brandColor = Color(0xFF065643);
    final bool isSelected = _avatarUrlController.text.trim() == url;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _avatarUrlController.text = url;
        });
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? brandColor : Colors.transparent,
            width: 2.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF065643),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildRateRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF065643).withValues(alpha: 0.6), size: 20),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13.5, color: Colors.black87),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14.5, color: const Color(0xFF065643)),
        ),
      ],
    );
  }

  // ==========================================
  // SHARED UTILITY BUILDERS FOR DASHBOARD
  // ==========================================
  Widget _buildAvailabilityCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF065643).withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (_isOnline ? const Color(0xFF065643) : Colors.amber).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isOnline ? Icons.sensors_rounded : Icons.sensors_off_rounded,
              color: _isOnline ? const Color(0xFF065643) : Colors.amber,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isOnline ? "Active & Accepting Clients" : "Calendar Paused",
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                    color: const Color(0xFF065643),
                  ),
                ),
                Text(
                  _isOnline ? "Your consultation slots are searchable" : "Emergency block mode active",
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    color: const Color(0xFF065643).withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isOnline,
            activeThumbColor: const Color(0xFF065643),
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() {
                _isOnline = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNextSessionHUD() {
    final approved = _approvedBookings;
    if (approved.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF065643), Color(0xFF0A7D62)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF065643).withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "No upcoming sessions",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Once client requests are approved, your next session will appear here.",
              style: GoogleFonts.outfit(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    final nextSession = approved.first;
    final String fullName = nextSession["clientId"]?["fullName"] ?? "Anonymous Client";
    final DateTime apptDate = DateTime.tryParse(nextSession["appointmentDate"] ?? "") ?? DateTime.now();
    final String timeStr = "${apptDate.day}/${apptDate.month}/${apptDate.year} at ${TimeOfDay.fromDateTime(apptDate).format(context)}";
    final String type = (nextSession["consultationType"] ?? "video").toString().toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF065643), Color(0xFF0A7D62)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$type SESSION",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                type == "CHAT"
                    ? Icons.chat_bubble_outline_rounded
                    : type == "AUDIO"
                        ? Icons.phone_rounded
                        : Icons.videocam_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            fullName,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeStr,
            style: GoogleFonts.outfit(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    "Session Logs",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF065643),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(
                    "Join Session",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TherapistCallScreen(
                          appointmentId: nextSession["_id"] ?? "",
                          clientName: fullName,
                          callType: (nextSession["consultationType"] ?? "video").toString().toLowerCase(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: [
        _buildStatCard("Bookings", "4 / 6", Icons.calendar_today_rounded),
        _buildStatCard("Rating", "4.95", Icons.star_rounded),
        _buildStatCard("Pending", "₹18,400", Icons.account_balance_wallet_rounded),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    const Color brandColor = Color(0xFF065643);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF9), // Clean soft warm daylight tint
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: brandColor.withValues(alpha: 0.08),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: brandColor.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🌟 Circular Brand Backing Badge
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: brandColor.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: brandColor,
              size: 15,
            ),
          ),
          const Spacer(),
          // 🌟 Clean Branded Metric Number
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: brandColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          // 🌟 Minimalist Subtitle Label
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: brandColor.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(dynamic req, int index) {
    final String fullName = req["clientId"]?["fullName"] ?? "Anonymous Client";
    final String initials = fullName.isNotEmpty
        ? fullName.split(" ").map((s) => s.isNotEmpty ? s[0] : "").join("").toUpperCase()
        : "A";
    final String type = (req["consultationType"] ?? "video").toString().toUpperCase();
    final DateTime apptDate = DateTime.tryParse(req["appointmentDate"] ?? "") ?? DateTime.now();
    final String timeStr = "${apptDate.day}/${apptDate.month}/${apptDate.year} at ${TimeOfDay.fromDateTime(apptDate).format(context)}";
    final String bookingId = req["_id"] ?? "";

    final String rawType = (req["consultationType"] ?? "video").toString().toLowerCase();
    int rate = 1500;
    if (rawType == "video") {
      rate = _videoRate;
    } else if (rawType == "audio") {
      rate = _audioRate;
    } else if (rawType == "chat") {
      rate = _chatRate;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF065643).withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF065643).withValues(alpha: 0.05),
                child: Text(
                  initials,
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF065643),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: const Color(0xFF065643),
                      ),
                    ),
                    Text(
                      "$type Consultation • ₹$rate",
                      style: GoogleFonts.outfit(
                        fontSize: 11.5,
                        color: const Color(0xFF065643).withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                timeStr,
                style: GoogleFonts.outfit(fontSize: 12.5, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF065643),
                    side: BorderSide(color: const Color(0xFF065643).withValues(alpha: 0.1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Decline",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onPressed: () => _handleRequestAction(bookingId, "declined"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF065643),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(
                    "Approve",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onPressed: () => _handleRequestAction(bookingId, "approved"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyInbox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF065643).withValues(alpha: 0.05),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.mark_email_read_outlined, size: 36, color: const Color(0xFF065643).withValues(alpha: 0.3)),
          const SizedBox(height: 10),
          Text(
            "Your Booking Inbox is Empty!",
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: const Color(0xFF065643).withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySlots() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF065643).withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_month_outlined, size: 28, color: const Color(0xFF065643).withValues(alpha: 0.3)),
          const SizedBox(height: 8),
          Text(
            "No availability slots configured.",
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: const Color(0xFF065643).withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  // === Bottom Navigation Bar ===
  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.dashboard_rounded, "Dashboard"),
          _buildNavItem(1, Icons.calendar_month_rounded, "Availability"),
          _buildNavItem(2, Icons.account_balance_wallet_rounded, "Earnings"),
          _buildNavItem(3, Icons.person_rounded, "Profile"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentTab == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _currentTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF065643) : const Color(0xFF065643).withValues(alpha: 0.35),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF065643) : const Color(0xFF065643).withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }
}
