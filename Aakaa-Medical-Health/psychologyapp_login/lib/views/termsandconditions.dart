import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
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
                  "Terms & Conditions",
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
                      "1. Introduction",
                      "Welcome to Aakaa. By using our app, you agree to these terms. Please read them carefully."
                    ),
                    _buildLegalSection(
                      "2. Use of Service",
                      "Aakaa provides mental wellness tools. You must use the app responsibly and comply with all applicable laws."
                    ),
                    _buildLegalSection(
                      "3. Privacy",
                      "Your privacy is important to us. Our Privacy Policy explains how we collect and use your information."
                    ),
                    _buildLegalSection(
                      "4. Medical Disclaimer",
                      "Aakaa is not a medical device. Always seek the advice of a physician or other qualified health provider with any questions you may have regarding a medical condition."
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
