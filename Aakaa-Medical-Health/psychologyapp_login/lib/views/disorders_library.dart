import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';
import 'package:psychologyapp_login/views/disorder_detail_screen.dart';

class DisordersLibrary extends StatefulWidget {
  const DisordersLibrary({super.key});

  @override
  State<DisordersLibrary> createState() => _DisordersLibraryState();
}

class _DisordersLibraryState extends State<DisordersLibrary> {
  final List<Map<String, dynamic>> _disorders = [
    {
      "title": "Anxiety Disorders",
      "icon": Icons.psychology_rounded,
      "description": "Understanding generalized anxiety, panic, and phobias.",
    },
    {
      "title": "Mood Disorders",
      "icon": Icons.wb_sunny_rounded,
      "description": "Exploring depression and bipolar spectrum conditions.",
    },
    {
      "title": "Sleep Disorders",
      "icon": Icons.bedtime_rounded,
      "description": "Insights into insomnia and sleep cycle regulation.",
    },
    {
      "title": "Stress & Trauma",
      "icon": Icons.spa_rounded,
      "description": "Navigating PTSD and chronic stress management.",
    },
  ];

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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                centerTitle: false,
                title: Text(
                  "Disorders Hub",
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
                    _buildSearchBar(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildDisorderCard(_disorders[index]),
                  childCount: _disorders.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: TextField(
        style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.w600),
        cursorColor: const Color(0xFF065643),
        decoration: InputDecoration(
          hintText: "Search library...",
          hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.4), fontSize: 15),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF065643), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildDisorderCard(Map<String, dynamic> disorder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF065643).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(disorder['icon'], color: const Color(0xFF065643), size: 24),
        ),
        title: Text(
          disorder['title'],
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF065643),
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          disorder['description'],
          style: GoogleFonts.outfit(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) => DisorderDetailScreen(disorder: disorder),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
      ),
    );
  }
}
