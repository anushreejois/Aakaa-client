import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/controllers/signup_loginfunctionality.dart';
import 'package:psychologyapp_login/views/clienteditprofile.dart';
import 'package:psychologyapp_login/views/clientlogin.dart';
import 'package:psychologyapp_login/views/clientnotification.dart';
import 'package:psychologyapp_login/views/languages.dart';
import 'package:psychologyapp_login/views/helpandsupport.dart';
import 'package:psychologyapp_login/views/about_us.dart';
import 'package:psychologyapp_login/views/message_hub.dart';
import 'package:psychologyapp_login/controllers/plan_controller.dart';
import 'package:psychologyapp_login/views/premium_gate_dialog.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';
import 'package:psychologyapp_login/controllers/user_controller.dart';

class ClientProfile extends StatefulWidget {
  final String email;
  final Function(int)? onNavigateToTab;
  const ClientProfile({super.key, required this.email, this.onNavigateToTab});

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {

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
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                centerTitle: false,
                title: Text(
                  "Profile",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF065643),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileHeader(),
                    const SizedBox(height: 32),
                    _buildSectionHeader("Account Settings"),
                    const SizedBox(height: 16),
                    _buildGroupedCard([
                      _buildSettingsTile(Icons.person_outline_rounded, "Edit Profile", null, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfile()))),
                      _buildSettingsTile(Icons.history_rounded, "Activity Logs", null, onTap: () => widget.onNavigateToTab?.call(1)),
                    ]),
                    const SizedBox(height: 32),
                    _buildSectionHeader("Preferences"),
                    const SizedBox(height: 16),
                    _buildGroupedCard([
                      _buildSettingsTile(Icons.notifications_none_rounded, "Notifications", null, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientNotification()))),
                      _buildSettingsTile(Icons.language_rounded, "Language", "English", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Languages()))),
                      _buildSettingsTile(Icons.chat_bubble_outline_rounded, "My Messages", null, onTap: _handleMessagingAccess),
                      _buildSettingsTile(Icons.help_outline_rounded, "Help & Support", null, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpAndSupport()))),
                      _buildSettingsTile(Icons.info_outline_rounded, "About Aakaa", null, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUs()))),
                    ]),
                    const SizedBox(height: 32),
                    _buildLogoutButton(),
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

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF065643),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return ValueListenableBuilder<UserModel>(
      valueListenable: UserController.userNotifier,
      builder: (context, user, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              const SizedBox(height: 16),
              Text(
                user.fullName,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF065643),
                ),
              ),
              Text(
                user.email.isNotEmpty ? user.email : widget.email,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGroupedCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String? trailingText, {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFF065643), size: 22),
      title: Text(
        title,
        style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.w500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 13),
            ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 14),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        SignupLoginFunctionality().signOutUser(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ClientLogin()),
          (route) => false,
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Center(
          child: Text(
            "Logout",
            style: GoogleFonts.outfit(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
