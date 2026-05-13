import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages>{
  String _selectedLanguage = "English";

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
                    "Languages",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Select your preferred language",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      _buildLanguageTile("English", "Recommended"),
                      _buildLanguageTile("Hindi", "हिंदी"),
                      _buildLanguageTile("Bengali", "বাংলা"),
                      _buildLanguageTile("Telugu", "తెలుగు"),
                      _buildLanguageTile("Marathi", "मরাठी"),
                      _buildLanguageTile("Tamil", "தமிழ்"),
                      
                      const SizedBox(height: 60),
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

  Widget _buildLanguageTile(String title, String subtitle) {
    bool isSelected = _selectedLanguage == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedLanguage = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFF065643) : Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: isSelected ? const Color(0xFF065643).withOpacity(0.8) : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) 
              const Icon(Icons.check_circle_rounded, color: Color(0xFF065643), size: 24),
          ],
        ),
      ),
    );
  }
}
