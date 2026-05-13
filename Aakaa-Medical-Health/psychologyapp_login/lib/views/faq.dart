import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FaQ extends StatefulWidget {
  const FaQ({super.key});

  @override
  State<FaQ> createState() => _FaQState();
}

class _FaQState extends State<FaQ>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF065643), Color(0xFF0A7D62), Color(0xFF065643)],
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
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  centerTitle: false,
                  title: Text(
                    "FAQ's",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
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
        ],
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
              color: Colors.white,
            ),
          ),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white.withOpacity(0.5),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(
                answer,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
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
