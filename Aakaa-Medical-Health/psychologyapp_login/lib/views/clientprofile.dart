import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:psychologyapp_login/views/clienteditprofile.dart';
import 'package:psychologyapp_login/views/clientlogin.dart';
import 'package:psychologyapp_login/views/clientnotification.dart';
import 'package:psychologyapp_login/views/helpandsupport.dart';
import 'package:psychologyapp_login/views/languages.dart';
import 'package:psychologyapp_login/views/clientplan.dart';
import 'package:psychologyapp_login/views/info.dart';
import 'package:psychologyapp_login/views/about_us.dart';

class ClientProfile extends StatefulWidget {
  final String email;
  final Function(int) onNavigateToTab;
  const ClientProfile({super.key, required this.email, required this.onNavigateToTab});

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile>{
  String get alternatescreenname => widget.email.split('@').first;
  String screenname = "";
  String get result => screenname.isNotEmpty ? screenname : alternatescreenname;
  String _selectedAvatar = "🧘"; // Using Emoji instead of Image
  String phoneNumber = "Add Phone Number";
  String dob = "Add Date of Birth";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> openProfileImage() async {
    final String? updatedAvatar = await Navigator.push<String?>(
      context, MaterialPageRoute(builder: (_) => EditProfile(currentAvatar: _selectedAvatar))
    );
    if(updatedAvatar != null){
      setState(() {
        _selectedAvatar = updatedAvatar;
      });
    }
  }
  
  Future<void> logout() async {
    await _auth.signOut();
  }  

  void _showEditDialog(String title, String initialValue, Function(String) onSave) {
    final controller = TextEditingController(text: initialValue == "Add Phone Number" || initialValue == "Add Date of Birth" ? "" : initialValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF065643).withOpacity(0.95),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit $title",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: TextField(
                  controller: controller,
                  style: GoogleFonts.outfit(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter $title",
                    hintStyle: GoogleFonts.outfit(color: Colors.white.withOpacity(0.3)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.5)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        onSave(controller.text);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF065643),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text("Save", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Premium Deep Green Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF065643), Color(0xFF0A7D62), Color(0xFF065643)],
              ),
            ),
          ),

          // Decorative Glass Elements
          Positioned(
            top: -50,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.05), Colors.transparent],
                ),
              ),
            ),
          ),

          CustomScrollView(
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
                      color: Colors.white,
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
                      
                      // Profile Header
                      _buildProfileHeader(),
                      
                      const SizedBox(height: 40),
                      
                      // Information Group
                      _buildSectionHeader("Account Information"),
                      const SizedBox(height: 12),
                      _buildGroupedCard([
                        _buildSettingsTile(
                          Icons.person_outline_rounded, 
                          "Username", 
                          result,
                          onTap: () => _showEditDialog("Username", result, (val) => setState(() => screenname = val)),
                        ),
                        _buildSettingsTile(
                          Icons.phone_outlined, 
                          "Phone", 
                          phoneNumber,
                          onTap: () => _showEditDialog("Phone", phoneNumber, (val) => setState(() => phoneNumber = val)),
                        ),
                        _buildSettingsTile(
                          Icons.cake_outlined, 
                          "Birthday", 
                          dob,
                          onTap: () => _showEditDialog("Birthday", dob, (val) => setState(() => dob = val)),
                        ),
                        _buildSettingsTile(
                          Icons.card_membership_rounded, 
                          "Plan", 
                          "Premium Access",
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientPlan())),
                        ),
                      ]),

                      const SizedBox(height: 32),
                      
                      // Preferences Group
                      _buildSectionHeader("Preferences"),
                      const SizedBox(height: 12),
                      _buildGroupedCard([
                        _buildSettingsTile(Icons.notifications_none_rounded, "Notifications", null, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientNotification()))),
                        _buildSettingsTile(Icons.language_rounded, "Language", "English", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Languages()))),
                        _buildSettingsTile(Icons.help_outline_rounded, "Help & Support", null, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpAndSupport()))),
                        _buildSettingsTile(Icons.info_outline_rounded, "About Aakaa", null, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUs()))),
                      ]),

                      const SizedBox(height: 40),
                      
                      // Logout Button
                      GestureDetector(
                        onTap: () {
                          logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const ClientLogin()),
                            (route) => false,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Log Out",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold, 
                              fontSize: 17, 
                              color: Colors.redAccent.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.4),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
              ),
              alignment: Alignment.center,
              child: _selectedAvatar.startsWith("http")
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(65),
                    child: Image.network(
                      _selectedAvatar,
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  )
                : Text(
                    _selectedAvatar,
                    style: const TextStyle(fontSize: 60),
                  ),
            ),
            GestureDetector(
              onTap: openProfileImage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_rounded, color: Color(0xFF065643), size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          result,
          style: GoogleFonts.outfit(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          widget.email,
          style: GoogleFonts.outfit(
            fontSize: 15,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupedCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String? value, {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white.withOpacity(0.2)),
        ],
      ),
    );
  }
}
