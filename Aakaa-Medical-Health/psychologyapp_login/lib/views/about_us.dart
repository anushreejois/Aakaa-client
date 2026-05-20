import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Premium AppBar
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
                  "About Aakaa",
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
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Logo
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF065643).withValues(alpha: 0.08),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
                        ),
                        child: const Icon(Icons.psychology_rounded, size: 64, color: Color(0xFF065643)),
                      ),
                    ),
                    const SizedBox(height: 48),

                    _buildSectionCard(
                      "Our Vision",
                      "To create a world where mental health support is accessible, empathetic, and personalized for every individual.",
                      Icons.visibility_outlined,
                    ),
                    const SizedBox(height: 20),

                    _buildSectionCard(
                      "Our Motto",
                      "Healing Hearts, Empowering Minds.",
                      Icons.auto_awesome_outlined,
                    ),
                    const SizedBox(height: 20),

                    _buildSectionCard(
                      "Our Purpose",
                      "Aakaa was born out of a necessity to bridge the gap between people and quality mental healthcare. We strive to provide a safe space for healing and growth through professional guidance and modern technology.",
                      Icons.favorite_border_rounded,
                    ),
                    const SizedBox(height: 20),

                    _buildSectionCard(
                      "Our Work",
                      "We connect users with certified therapists, provide tools for daily mindfulness, and offer educational resources to break the stigma surrounding mental health.",
                      Icons.work_outline_rounded,
                    ),

                    const SizedBox(height: 60),
                    
                    Center(
                      child: Text(
                        "v1.0.0 • Made with ❤️ by Aakaa",
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: const Color(0xFF065643).withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF065643).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: const Color(0xFF065643), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065643),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.outfit(
              fontSize: 16,
              height: 1.6,
              color: const Color(0xFF065643).withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
