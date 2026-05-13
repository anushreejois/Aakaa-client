import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/views/findtherapist.dart';
import 'package:psychologyapp_login/views/clientnotification.dart';
import 'package:psychologyapp_login/views/daily_affirmation.dart';
import 'package:psychologyapp_login/views/disorders_library.dart';
import 'package:psychologyapp_login/views/message_hub.dart';
import 'package:psychologyapp_login/controllers/plan_controller.dart';
import 'package:psychologyapp_login/views/premium_gate_dialog.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';

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

  void _handleMessagingAccess() {
    if (PlanController.isPremiumMember) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MessageHub()));
    } else {
      showDialog(
        context: context,
        builder: (context) => const PremiumAccessDialog(featureName: "Direct Messaging"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZenBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 140.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
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
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      result,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: Icon(Icons.notifications_none_rounded, color: Colors.white.withOpacity(0.8), size: 28),
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
                    _buildFeaturedCard(),
                    const SizedBox(height: 32),
                    Text(
                      "Quick Actions",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuTile(Icons.auto_awesome_outlined, "Daily Affirmation", "Your positive thought for today", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyAffirmation()))),
                    const SizedBox(height: 12),
                    _buildMenuTile(Icons.psychology_outlined, "Disorders", "Educational resources", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DisordersLibrary()))),
                    const SizedBox(height: 12),
                    _buildMenuTile(Icons.person_search_outlined, "Find Therapist", "Book your next session", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FindTherapist()))),
                    const SizedBox(height: 12),
                    _buildMenuTile(
                      Icons.chat_bubble_outline_rounded, 
                      "Message Doctor", 
                      "View your conversations",
                      onTap: _handleMessagingAccess,
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withOpacity(0.06), // Very subtle glass
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "NEW FEATURE",
                style: GoogleFonts.outfit(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Mental Healthcare",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Book your next online appointments seamlessly",
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.5),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04), // Ultra subtle glass
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.outfit(
            color: Colors.white.withOpacity(0.4),
            fontSize: 13,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white.withOpacity(0.2)),
      ),
    );
  }
}
