import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';
import '../controllers/activity_controller.dart';

class GratitudePractice extends StatefulWidget {
  const GratitudePractice({super.key});

  @override
  State<GratitudePractice> createState() => _GratitudePracticeState();
}

class _GratitudePracticeState extends State<GratitudePractice> {
  final TextEditingController _controller = TextEditingController();

  void _addGratitude() {
    if (_controller.text.trim().isNotEmpty) {
      ActivityController.addGratitude(_controller.text.trim());
      _controller.clear();
    }
  }

  void _complete() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Your gratitude has been released to the universe.", style: GoogleFonts.outfit(color: Colors.white)),
        backgroundColor: const Color(0xFF0A7D62),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF065643), size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What made you\nsmile today?",
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Tap to add a bubble of gratitude.",
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF065643).withValues(alpha: 0.7),
                          fontSize: 16,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Gratitude Bubbles List
                      Expanded(
                        child: ValueListenableBuilder<List<String>>(
                          valueListenable: ActivityController.gratitudeNotesNotifier,
                          builder: (context, notes, child) {
                            if (notes.isEmpty) return _buildEmptyState();
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                return _buildGratitudeBubble(notes[index], index);
                              },
                            );
                          },
                        ),
                      ),
                      
                      // Input Area
                      _buildInputArea(),
                      
                      const SizedBox(height: 20),
                      
                      // Completion Button
                      ValueListenableBuilder<List<String>>(
                        valueListenable: ActivityController.gratitudeNotesNotifier,
                        builder: (context, notes, child) {
                          if (notes.isEmpty) return const SizedBox.shrink();
                          return SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF065643).withValues(alpha: 0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _complete,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                child: Text(
                                  "Send Gratitude",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bubble_chart_rounded, size: 80, color: const Color(0xFF065643).withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            "Your jar is empty.",
            style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildGratitudeBubble(String text, int index) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(text),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index > 5 ? 0 : index * 100)),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF065643).withValues(alpha: 0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite_rounded, color: Color(0xFF0A7D62), size: 20),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF065643),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
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
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _controller,
                cursorColor: const Color(0xFF065643),
                style: GoogleFonts.outfit(color: const Color(0xFF065643)),
                decoration: InputDecoration(
                  hintText: "Add something...",
                  hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.4)),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _addGratitude(),
              ),
            ),
          ),
          GestureDetector(
            onTap: _addGratitude,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF065643),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
