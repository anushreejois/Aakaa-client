import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/zen_background.dart';

class TherapistChatScreen extends StatefulWidget {
  final String clientName;
  final String initials;
  final String clientId;

  const TherapistChatScreen({
    super.key,
    required this.clientName,
    required this.initials,
    required this.clientId,
  });

  @override
  State<TherapistChatScreen> createState() => _TherapistChatScreenState();
}

class _TherapistChatScreenState extends State<TherapistChatScreen> {
  List<dynamic> _messages = [];
  bool _isLoading = false;
  Timer? _pollingTimer;

  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchChatHistory(showLoader: true);
    
    // Set up periodic 5-second background polling refresh loop
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _fetchChatHistory(showLoader: false);
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchChatHistory({required bool showLoader}) async {
    if (showLoader) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) return;

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/chat/history/${widget.clientId}");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          final List<dynamic> fetchedMessages = data["messages"] ?? [];
          
          if (mounted) {
            setState(() {
              _messages = fetchedMessages;
            });
            // Auto scroll to bottom on first load
            if (showLoader) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching chat history: $e");
    } finally {
      if (showLoader && mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    _textController.clear();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null) return;

      const String backendUrl = "http://10.0.2.2:5000";
      final url = Uri.parse("$backendUrl/api/chat/send");
      
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "recipientId": widget.clientId,
          "messageText": text,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success" && data["chatMessage"] != null) {
          setState(() {
            _messages.add(data["chatMessage"]);
          });
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        }
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to send message.", style: GoogleFonts.outfit()),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZenBackground(
        child: SafeArea(
          child: Column(
            children: [
              // 🌟 Premium Dynamic Chat Header
              _buildChatHeader(context),

              // 🌟 Messages Scroll List
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Color(0xFF065643)),
                      )
                    : _messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  size: 40,
                                  color: const Color(0xFF065643).withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "No messages yet. Send a welcoming note!",
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF065643).withValues(alpha: 0.6),
                                    fontSize: 13.5,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            physics: const BouncingScrollPhysics(),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final msg = _messages[index];
                              // If senderId matches clientId -> it is client's message, else doctor's message
                              final isDoctor = msg["senderId"] != widget.clientId;
                              return _buildMessageBubble(msg, isDoctor);
                            },
                          ),
              ),

              // 🌟 Message Input Bar
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
            onPressed: () => Navigator.pop(context),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF065643).withValues(alpha: 0.1),
            child: Text(
              widget.initials,
              style: GoogleFonts.outfit(
                color: const Color(0xFF065643),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.clientName,
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065643),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Online Consultation",
                      style: GoogleFonts.outfit(
                        fontSize: 11.5,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.videocam_rounded, color: Color(0xFF065643)),
            onPressed: () {
              HapticFeedback.mediumImpact();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(dynamic msg, bool isDoctor) {
    final String text = msg["messageText"] ?? "";
    final String timestampStr = msg["timestamp"] ?? "";
    
    // Formatting timestamp
    String timeFormatted = "Just now";
    if (timestampStr.isNotEmpty) {
      final parsedDate = DateTime.tryParse(timestampStr);
      if (parsedDate != null) {
        timeFormatted = TimeOfDay.fromDateTime(parsedDate.toLocal()).format(context);
      }
    }

    return Align(
      alignment: isDoctor ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isDoctor ? const Color(0xFF065643) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isDoctor ? const Radius.circular(20) : Radius.zero,
            bottomRight: isDoctor ? Radius.zero : const Radius.circular(20),
          ),
          border: isDoctor
              ? null
              : Border.all(
                  color: const Color(0xFF065643).withValues(alpha: 0.08),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: GoogleFonts.outfit(
                color: isDoctor ? Colors.white : Colors.black87,
                fontSize: 14.5,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeFormatted,
                style: GoogleFonts.outfit(
                  color: isDoctor ? Colors.white70 : Colors.black38,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _textController,
                style: GoogleFonts.outfit(fontSize: 14.5),
                decoration: InputDecoration(
                  hintText: "Type professional advice...",
                  hintStyle: GoogleFonts.outfit(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFF065643),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
