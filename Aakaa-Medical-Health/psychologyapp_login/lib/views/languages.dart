import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';
import '../controllers/user_controller.dart';

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: ValueListenableBuilder<String>(
          valueListenable: UserController.languageNotifier,
          builder: (context, currentLanguage, child) {
            return CustomScrollView(
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
                      "Languages",
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
                          "Select your preferred language",
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: const Color(0xFF065643).withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        _buildLanguageTile("English", "Recommended", currentLanguage),
                        _buildLanguageTile("Hindi", "हिंदी", currentLanguage),
                        _buildLanguageTile("Bengali", "বাংলা", currentLanguage),
                        _buildLanguageTile("Telugu", "తెలుగు", currentLanguage),
                        _buildLanguageTile("Marathi", "मराठी", currentLanguage),
                        _buildLanguageTile("Tamil", "தமிழ்", currentLanguage),
                        
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLanguageTile(String title, String subtitle, String currentLanguage) {
    bool isSelected = currentLanguage == title;
    return GestureDetector(
      onTap: () {
        UserController.updateLanguage(title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Language updated to $title.", style: GoogleFonts.outfit(color: Colors.white)),
            backgroundColor: const Color(0xFF0A7D62),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF065643).withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: isSelected ? const Color(0xFF065643) : const Color(0xFF065643).withValues(alpha: 0.08),
            width: isSelected ? 2 : 1,
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
                      color: const Color(0xFF065643),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: const Color(0xFF065643).withValues(alpha: 0.7),
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
