import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/views/therapists/chat_screen.dart';
import 'dart:ui';
import 'package:psychologyapp_login/widgets/zen_background.dart';

class MessageHub extends StatefulWidget {
  const MessageHub({super.key});

  @override
  State<MessageHub> createState() => _MessageHubState();
}

class _MessageHubState extends State<MessageHub> {
  final List<Map<String, dynamic>> _conversations = [
    {
      "name": "Dr. Sarah Chen",
      "specialty": "Cognitive Behavioral Therapy",
      "lastMessage": "How have you been feeling since our last session?",
      "time": "10:30 AM",
      "unreadCount": 2,
      "isOnline": true,
      "avatar": "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop",
    },
    {
      "name": "Dr. Marcus Thorne",
      "specialty": "Sleep & Wellness Specialist",
      "lastMessage": "The new meditation routine should help with your insomnia.",
      "time": "Yesterday",
      "unreadCount": 0,
      "isOnline": false,
      "avatar": "https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&h=400&fit=crop",
    },
    {
      "name": "Elena Rodriguez",
      "specialty": "Mindfulness Coach",
      "lastMessage": "Great progress on your daily gratitude log!",
      "time": "Mon",
      "unreadCount": 0,
      "isOnline": true,
      "avatar": "https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=400&h=400&fit=crop",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZenBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                centerTitle: false,
                title: Text(
                  "Messages",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildConversationTile(_conversations[index]),
                  childCount: _conversations.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.w600),
        cursorColor: const Color(0xFF065643),
        decoration: InputDecoration(
          hintText: "Search conversations...",
          hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withOpacity(0.4), fontSize: 15),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF065643), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> convo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ListTile(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(therapistName: convo['name']))),
            contentPadding: const EdgeInsets.all(16),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(convo['avatar']),
                ),
                if (convo['isOnline'])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF065643), width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              convo['name'],
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  convo['specialty'],
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  convo['lastMessage'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  convo['time'],
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                if (convo['unreadCount'] > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      convo['unreadCount'].toString(),
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF065643),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
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
