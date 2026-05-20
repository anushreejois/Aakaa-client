import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';
import '../controllers/activity_controller.dart';

class ReflectiveJournal extends StatefulWidget {
  const ReflectiveJournal({super.key});

  @override
  State<ReflectiveJournal> createState() => _ReflectiveJournalState();
}

class _ReflectiveJournalState extends State<ReflectiveJournal> {
  final TextEditingController _contentController = TextEditingController();
  bool _isSaving = false;

  void _saveEntry() {
    if (_contentController.text.trim().isEmpty) return;
    setState(() => _isSaving = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        ActivityController.addJournalEntry(_contentController.text.trim());
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Your reflection has been released.", style: GoogleFonts.outfit(color: Colors.white)),
            backgroundColor: const Color(0xFF0A7D62),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: Stack(
          children: [
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
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF065643), size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        GestureDetector(
                          onTap: _saveEntry,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF065643).withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
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
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Dear Mind,",
                            style: GoogleFonts.outfit(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF065643),
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Today is a new chapter. Speak your truth.",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF065643).withValues(alpha: 0.7),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 48),
                          
                          // Pristine White Writing Area
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF065643).withValues(alpha: 0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
                            ),
                            child: TextField(
                              controller: _contentController,
                              maxLines: 15,
                              cursorColor: const Color(0xFF065643),
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                color: const Color(0xFF065643),
                                height: 1.8,
                              ),
                              decoration: InputDecoration(
                                hintText: "Let your thoughts flow like water...",
                                hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.4)),
                                border: InputBorder.none,
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
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF065643)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
