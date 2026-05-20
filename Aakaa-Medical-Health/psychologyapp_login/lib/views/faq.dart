import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';

class FaQ extends StatefulWidget {
  const FaQ({super.key});

  @override
  State<FaQ> createState() => _FaQState();
}

class _FaQState extends State<FaQ> {
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
                  "FAQ's",
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
                  children: [
                    const SizedBox(height: 10),
                    _buildFaqTile(
                      "What is Aakaa?",
                      "Aakaa is a comprehensive mental wellness app designed to help you manage stress, anxiety and improve your overall mental health through guided meditation, mood tracking, breathing exercises and journaling tools."
                    ),
                    _buildFaqTile(
                      "Is Aakaa free to use?",
                      "Aakaa will offer a free tier with essential features, as well as a premium subscription that unlocks advanced tools, personalized plans and exclusive content from mental health professionals."
                    ),
                    _buildFaqTile(
                      "Is my data private and secure?",
                      "Absolutely. Your privacy is our top priority. All your data is encrypted and stored securely. We never share your personal information with third parties."
                    ),
                    _buildFaqTile(
                      "Can Aakaa replace therapy?",
                      "While Aakaa provides valuable tools, it is not a replacement for professional therapy. We recommend consulting with a mental health professional for serious concerns."
                    ),
                    _buildFaqTile(
                      "What devices will Aakaa be available on?",
                      "Aakaa will be available on both iOS and Android devices at launch. We're also exploring a web version for the future."
                    ),
                    _buildFaqTile(
                      "Can I use Aakaa offline?",
                      "Many features including guided meditations and journaling will be available offline once content is downloaded."
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

  Widget _buildFaqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Text(
            question,
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF065643),
            ),
          ),
          iconColor: const Color(0xFF065643),
          collapsedIconColor: const Color(0xFF065643).withValues(alpha: 0.5),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(
                answer,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF065643).withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
