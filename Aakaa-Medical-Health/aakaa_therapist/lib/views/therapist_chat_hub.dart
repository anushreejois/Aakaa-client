import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/zen_background.dart';
import 'therapist_chat_screen.dart';

class TherapistChatHub extends StatefulWidget {
  const TherapistChatHub({super.key});

  @override
  State<TherapistChatHub> createState() => _TherapistChatHubState();
}

class _TherapistChatHubState extends State<TherapistChatHub> {
  List<dynamic> _conversations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    setState(() {
      _isLoading = true;
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
          final List<dynamic> allBookings = data["bookings"] ?? [];
          
          // Filter for approved bookings only
          final approvedBookings = allBookings.where((b) => b["status"] == "approved").toList();

          // Group unique clients by their _id
          final Map<String, dynamic> uniqueClients = {};
          for (var b in approvedBookings) {
            final client = b["clientId"];
            if (client != null && client["_id"] != null) {
              uniqueClients[client["_id"]] = client;
            }
          }

          setState(() {
            _conversations = uniqueClients.values.toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching conversations: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // 🌟 Premium Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Messaging Hub",
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🌟 Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF065643).withValues(alpha: 0.08),
                    ),
                  ),
                  child: TextField(
                    style: GoogleFonts.outfit(fontSize: 14.5),
                    decoration: InputDecoration(
                      hintText: "Search active clients...",
                      hintStyle: GoogleFonts.outfit(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF065643)),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🌟 Conversation List
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Color(0xFF065643)),
                        )
                      : _conversations.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 48,
                                    color: const Color(0xFF065643).withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No active client conversations yet.",
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF065643).withValues(alpha: 0.6),
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: _conversations.length,
                              separatorBuilder: (_, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final client = _conversations[index];
                                final String fullName = client["fullName"] ?? "Anonymous Client";
                                final String initials = fullName.isNotEmpty
                                    ? fullName.split(" ").map((s) => s.isNotEmpty ? s[0] : "").join("").toUpperCase()
                                    : "A";
                                final String clientId = client["_id"] ?? "";

                                return GestureDetector(
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TherapistChatScreen(
                                          clientName: fullName,
                                          initials: initials,
                                          clientId: clientId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: const Color(0xFF065643).withValues(alpha: 0.08),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: const Color(0xFF065643).withValues(alpha: 0.05),
                                          child: Text(
                                            initials,
                                            style: GoogleFonts.outfit(
                                              color: const Color(0xFF065643),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                fullName,
                                                style: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.5,
                                                  color: const Color(0xFF065643),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Tap to begin professional advice session",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 12.5,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: const Color(0xFF065643).withValues(alpha: 0.3),
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
        ),
      ),
    );
  }
}
