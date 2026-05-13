import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class ReflectiveJournal extends StatefulWidget {
  const ReflectiveJournal({super.key});

  @override
  State<ReflectiveJournal> createState() => _ReflectiveJournalState();
}

class _ReflectiveJournalState extends State<ReflectiveJournal> {
  final TextEditingController _contentController = TextEditingController();
  bool _isSaving = false;

  void _saveEntry() {
    setState(() => _isSaving = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isSaving = false);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF065643),
      body: Stack(
        children: [
          // Ambient Animated Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A7D62), Color(0xFF065643)],
                ),
              ),
            ),
          ),
          
          // Floating Decorative Orbs
          Positioned(
            top: 100,
            right: -50,
            child: _buildOrb(150, Colors.white.withOpacity(0.05)),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: _buildOrb(200, Colors.white.withOpacity(0.03)),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      GestureDetector(
                        onTap: _saveEntry,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Text(
                            "Release",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Dear Mind,",
                          style: GoogleFonts.outfit(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Today is a new chapter. Speak your truth.",
                          style: GoogleFonts.outfit(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 48),
                        
                        // Glassmorphic Writing Area
                        ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: TextField(
                                controller: _contentController,
                                maxLines: 15,
                                cursorColor: Colors.white54,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.8,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Let your thoughts flow like water...",
                                  hintStyle: GoogleFonts.outfit(color: Colors.white24),
                                  border: InputBorder.none,
                                ),
                              ),
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
          
          if (_isSaving)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}
