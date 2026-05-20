import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';

class PrivacyPolicies extends StatefulWidget {
  const PrivacyPolicies({super.key});

  @override
  State<PrivacyPolicies> createState() => _PrivacyPoliciesState();
}

class _PrivacyPoliciesState extends State<PrivacyPolicies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
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
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                centerTitle: false,
                title: Text(
                  "Privacy Policy",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF065643),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Last updated: May 2024",
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: const Color(0xFF065643).withValues(alpha: 0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildLegalSection(
                      "1. Data Collection",
                      "We collect information that you provide directly to us, such as when you create an account, participate in a session, or communicate with us."
                    ),
                    _buildLegalSection(
                      "2. How We Use Your Data",
                      "We use the information we collect to provide, maintain, and improve our services, and to develop new tools for mental wellness."
                    ),
                    _buildLegalSection(
                      "3. Data Sharing",
                      "We do not share your personal information with third parties except as described in this policy or with your consent."
                    ),
                    _buildLegalSection(
                      "4. Your Choices",
                      "You have the right to access, update, or delete your personal information at any time through the app settings."
                    ),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF065643),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: const Color(0xFF065643).withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
