import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';
import 'package:psychologyapp_login/views/findtherapist.dart';

class DisorderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> disorder;

  const DisorderDetailScreen({super.key, required this.disorder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF065643).withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.15), width: 2),
                        ),
                        child: Icon(disorder['icon'], color: const Color(0xFF065643), size: 50),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7F5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        disorder['title'],
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Overview",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        disorder['description'],
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF065643).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded, color: Color(0xFF065643), size: 24),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "Professional help is the most effective way to manage and overcome these symptoms. Our certified therapists are here to guide you.",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF065643),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 300),
                                pageBuilder: (context, animation, secondaryAnimation) => const FindTherapist(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(opacity: animation, child: child);
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF065643),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 0,
                          ),
                          child: Text(
                            "Find a Therapist",
                            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
