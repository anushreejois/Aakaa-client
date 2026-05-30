import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/zen_background.dart';
import '../../controllers/signup_loginfunctionality.dart';

class ChatScreen extends StatefulWidget {
  final String therapistName;

  const ChatScreen({super.key, required this.therapistName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Real Chat State
  final List<_ChatMessage> _messages = [];
  bool _isLoading = true;
  String _errorMessage = "";
  Timer? _syncTimer;
  
  // Default static therapist BSON ID for development/testing
  final String _recipientId = "665000000000000000000001";

  @override
  void initState() {
    super.initState();
    _fetchChatHistory(initialLoad: true);
    
    // Auto-poll for new messages every 2.5 seconds when active
    _syncTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      _fetchChatHistory(initialLoad: false);
    });
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchChatHistory({required bool initialLoad}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null || token.isEmpty) return;

      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/chat/history/$_recipientId");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          final List<dynamic> rawMessages = data["messages"] ?? [];
          
          final List<_ChatMessage> loadedMessages = rawMessages.map((msg) {
            final String sender = msg["senderId"] ?? "";
            // If sender is NOT the current recipient (therapist), it is me
            final bool isMe = sender != _recipientId;
            return _ChatMessage(
              text: msg["messageText"] ?? "",
              isMe: isMe,
              time: _formatTime(msg["timestamp"]),
            );
          }).toList();

          // Scroll to bottom only if new messages have arrived
          final bool hasNewMessages = loadedMessages.length != _messages.length;

          if (mounted) {
            setState(() {
              _messages.clear();
              _messages.addAll(loadedMessages);
              _isLoading = false;
              _errorMessage = "";
            });
            
            if (hasNewMessages && _messages.isNotEmpty) {
              _scrollToBottom();
            }
          }
        }
      } else {
        if (initialLoad && mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = "Failed to load chat history.";
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching chat: $e");
      if (initialLoad && mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Connection error. Ensure server is running.";
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Clear input area immediately to optimize UX
    _controller.clear();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null || token.isEmpty) return;

      // Append locally for instant visual response
      final myNewMsg = _ChatMessage(
        text: text,
        isMe: true,
        time: TimeOfDay.now().format(context),
      );

      setState(() {
        _messages.add(myNewMsg);
      });
      _scrollToBottom();

      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/chat/send");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "recipientId": _recipientId,
          "messageText": text
        }),
      );

      if (response.statusCode != 201) {
        debugPrint("Error sending message to backend.");
      }
    } catch (e) {
      debugPrint("Exception sending chat: $e");
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "Just now";
    try {
      final date = DateTime.parse(isoString).toLocal();
      final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } catch (e) {
      return "Just now";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: Column(
          children: [
            // Premium Daylight AppBar
            _buildAppBar(),
            
            Expanded(
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF065643)))
                  : _errorMessage.isNotEmpty 
                      ? _buildErrorPlaceholder()
                      : _messages.isEmpty
                          ? _buildEmptyPlaceholder()
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              physics: const BouncingScrollPhysics(),
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                return _buildMessageBubble(_messages[index]);
                              },
                            ),
            ),
            
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10, 
        bottom: 20, 
        left: 16, 
        right: 16
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: const Color(0xFF065643).withValues(alpha: 0.08))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1), width: 2),
                  image: const DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1559839734-2b71f153678e?w=400&h=400&fit=crop"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.therapistName,
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF065643),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Always here to help',
                  style: GoogleFonts.outfit(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.videocam_outlined, color: const Color(0xFF065643).withValues(alpha: 0.8)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: const Color(0xFF065643).withValues(alpha: 0.8)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline_rounded, color: const Color(0xFF065643).withValues(alpha: 0.2), size: 64),
            const SizedBox(height: 24),
            Text(
              "No messages yet",
              style: GoogleFonts.outfit(
                color: const Color(0xFF065643),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start the conversation! Say hello to your matched therapist.",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: message.isMe 
                    ? const Color(0xFF065643)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: Radius.circular(message.isMe ? 24 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 24),
                ),
                border: Border.all(
                  color: message.isMe 
                      ? Colors.transparent 
                      : const Color(0xFF065643).withValues(alpha: 0.08),
                ),
                boxShadow: message.isMe ? [] : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: GoogleFonts.outfit(
                  color: message.isMe ? Colors.white : const Color(0xFF065643),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message.time,
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: message.isMe ? Colors.grey[500] : Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: 24, 
        right: 24, 
        bottom: MediaQuery.of(context).padding.bottom + 20,
        top: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFF065643).withValues(alpha: 0.08))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF065643).withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      cursorColor: const Color(0xFF065643),
                      style: GoogleFonts.outfit(color: const Color(0xFF065643), fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.4)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline_rounded, color: const Color(0xFF065643).withValues(alpha: 0.6)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF065643).withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  _ChatMessage({required this.text, required this.isMe, required this.time});
}
