import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/views/faq.dart';
import 'package:psychologyapp_login/views/privacypolicies.dart';
import 'package:psychologyapp_login/views/reportaproblem.dart';
import 'package:psychologyapp_login/views/termsandconditions.dart';
import '../widgets/zen_background.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
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
                  "Help & Support",
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
                      "How can we help you today?",
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: const Color(0xFF065643).withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    _buildHelpCard(
                      Icons.question_answer_outlined, 
                      "FAQ's", 
                      "Common questions and answers", 
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FaQ())),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildHelpCard(
                      Icons.bug_report_outlined, 
                      "Report a Problem", 
                      "Let us know if something isn't working", 
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportAProblem())),
                    ),
                    const SizedBox(height: 40),
                    
                    Text(
                      "Legal",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildLegalTile("Terms & Conditions", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsAndConditions()))),
                    _buildLegalTile("Privacy Policies", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicies()))),
                    
                    const SizedBox(height: 48),
                    
                    _buildDashboardButton(),
                    
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

  Widget _buildHelpCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF065643).withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF065643).withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF065643),
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF065643).withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: const Color(0xFF065643).withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalTile(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF065643).withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF065643),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: const Color(0xFF065643).withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF065643), Color(0xFF0A7D62)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF065643).withValues(alpha: 0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "Back to Dashboard",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
