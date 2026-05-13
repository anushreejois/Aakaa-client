import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/views/findtherapist.dart';
import 'package:psychologyapp_login/views/clientnotification.dart';
import 'package:psychologyapp_login/views/daily_affirmation.dart';
import 'package:psychologyapp_login/views/disorders_library.dart';

class ClientMenu extends StatefulWidget {
  final String email;
  const ClientMenu({super.key, required this.email});

  @override
  State<ClientMenu> createState() => _ClientMenuState();
}

class _ClientMenuState extends State<ClientMenu>{
  String get alternatescreenname => widget.email.split('@').first;
  String screenname = "";
  String get result => screenname.isNotEmpty ? screenname : alternatescreenname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Premium Header with Welcome Message
          SliverAppBar(
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFFFF7F5),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              centerTitle: false,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF065643).withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    result,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF065643),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              background: Container(color: const Color(0xFFFFF7F5)),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF065643), size: 28),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientNotification())),
                ),
              ),
            ],
            automaticallyImplyLeading: false,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Promo Card
                  _buildFeaturedCard(),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    "Quick Actions",
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF065643),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildMenuTile(Icons.auto_awesome_outlined, "Daily Affirmation", "Your positive thought for today", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyAffirmation()))),
                  const SizedBox(height: 12),
                  _buildMenuTile(Icons.psychology_outlined, "Disorders", "Educational resources", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DisordersLibrary()))),
                  const SizedBox(height: 12),
                  _buildMenuTile(Icons.person_search_outlined, "Find Therapist", "Book your next session", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FindTherapist()))),
                  const SizedBox(height: 12),
                  _buildMenuTile(Icons.chat_bubble_outline_rounded, "Message Doctor", "View your conversations"),
                  
                  const SizedBox(height: 120), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF065643), Color(0xFF0A7D62)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Abstract Decorative Shapes
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "NEW FEATURE",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Mental\nHealthcare",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFFFF7F5),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Book your next online\nappointments seamlessly",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFFFF7F5).withOpacity(0.8),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF065643).withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: const Color(0xFF065643), size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF065643),
            fontSize: 17,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.outfit(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF065643)),
        onTap: onTap,
      ),
    );
  }
}
