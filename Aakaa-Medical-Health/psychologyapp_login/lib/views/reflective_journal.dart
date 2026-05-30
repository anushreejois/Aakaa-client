import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/zen_background.dart';
import '../controllers/activity_controller.dart';
import '../controllers/plan_controller.dart';
import '../controllers/signup_loginfunctionality.dart';
import 'clientsubscription.dart';

class ReflectiveJournal extends StatefulWidget {
  const ReflectiveJournal({super.key});

  @override
  State<ReflectiveJournal> createState() => _ReflectiveJournalState();
}

class _ReflectiveJournalState extends State<ReflectiveJournal> {
  final TextEditingController _contentController = TextEditingController();
  bool _isSaving = false;
  bool _showAnalysis = false;

  // Real AI analysis results
  String _detectedSentiment = "Peaceful Reflection";
  Color _sentimentColor = const Color(0xFF00C853);
  String _detectedDistortion = "None detected (Healthy emotional waves)";
  String _breakthroughAdvice = "You expressed your emotions cleanly. Keep breathing and staying present.";

  Color _parseHexColor(String hexStr) {
    try {
      String cleanHex = hexStr.replaceAll('#', '');
      if (cleanHex.length == 6) {
        cleanHex = 'FF$cleanHex';
      }
      return Color(int.parse('0x$cleanHex'));
    } catch (e) {
      return const Color(0xFF0A7D62);
    }
  }

  Future<void> _saveEntry() async {
    final text = _contentController.text.trim();
    if (text.isEmpty) return;
    
    setState(() => _isSaving = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token") ?? "";
      
      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/ai/analyze-journal");
      
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"content": text}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == "success") {
        ActivityController.addJournalEntry(text);
        
        setState(() {
          _detectedSentiment = data["sentiment"] ?? "Calm Spectrum";
          _sentimentColor = _parseHexColor(data["sentimentColor"] ?? "#0A7D62");
          _detectedDistortion = data["distortion"] ?? "None detected";
          _breakthroughAdvice = data["advice"] ?? "Your reflection has been released successfully.";
          _isSaving = false;
          _showAnalysis = true;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Your reflection has been released.", style: GoogleFonts.outfit(color: Colors.white)),
              backgroundColor: const Color(0xFF0A7D62),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        throw Exception(data["message"] ?? "Analysis failed");
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("AI Analysis failed. Showing mock analysis locally.", style: GoogleFonts.outfit(color: Colors.white)),
            backgroundColor: Colors.amber[800],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Fallback to local simulated mock analysis to ensure zero breakage
        ActivityController.addJournalEntry(text);
        _generateAnalysisMock(text);
        setState(() {
          _showAnalysis = true;
        });
      }
    }
  }

  void _generateAnalysisMock(String text) {
    String t = text.toLowerCase();
    if (t.contains("sad") || t.contains("depressed") || t.contains("cry") || t.contains("alone")) {
      _detectedSentiment = "Melancholic Waves";
      _sentimentColor = const Color(0xFFFF8A00);
      _detectedDistortion = "Emotional Reasoning";
      _breakthroughAdvice = "You are feeling intense sorrow, which makes things seem hopeless right now. Remember: feelings are waves, not facts. Let them wash over you without defining your future.";
    } else if (t.contains("anxious") || t.contains("stressed") || t.contains("worry") || t.contains("scared") || t.contains("panic")) {
      _detectedSentiment = "Anxious Energy";
      _sentimentColor = const Color(0xFFFF5252);
      _detectedDistortion = "Catastrophizing (Assuming the worst)";
      _breakthroughAdvice = "Your brain is attempting to forecast danger. Gently remind your nervous system that you are in the safe, quiet space of the present moment. Focus on 3 things you can see.";
    } else if (t.contains("hate") || t.contains("angry") || t.contains("annoyed") || t.contains("mad") || t.contains("worst")) {
      _detectedSentiment = "Frustrated / Irritated";
      _sentimentColor = const Color(0xFFE040FB);
      _detectedDistortion = "All-or-Nothing Thinking";
      _breakthroughAdvice = "When angry, it's easy to view everything through an extreme lens. Try to look for the grey areas—every challenging event contains parts that are neutral or workable.";
    } else {
      _detectedSentiment = "Calm & Centered";
      _sentimentColor = const Color(0xFF0A7D62);
      _detectedDistortion = "Healthy Core Intention";
      _breakthroughAdvice = "Your thoughts show beautiful self-awareness and balance. Continuing this journaling discipline will strengthen your emotional resilience dramatically.";
    }
  }

  @override
  Widget build(BuildContext context) {
    int planIndex = PlanController.currentPlanIndex;
    bool isFreemium = planIndex == 0;
    bool isBasic = planIndex == 1;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643), size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                        if (!_showAnalysis)
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
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!_showAnalysis) ...[
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
                            const SizedBox(height: 32),
                            
                            // Writing Canvas
                            Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF065643).withValues(alpha: 0.04),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                                border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.04)),
                              ),
                              child: TextField(
                                controller: _contentController,
                                maxLines: 12,
                                cursorColor: const Color(0xFF065643),
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  color: const Color(0xFF065643),
                                  height: 1.8,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Let your thoughts flow like water...",
                                  hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.3)),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ] else ...[
                            // Post-release analysis view
                            const SizedBox(height: 20),
                            Text(
                              "Released & Map",
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF065643),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Your thoughts are safely released into light. Below is your clinical wave translation.",
                              style: GoogleFonts.outfit(
                                color: Colors.grey[600],
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // The AI Breakthrough Diagnostic Card Block
                            Stack(
                              children: [
                                // Actual Analysis View (rendered normally but blurred for Freemium)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(28),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.03),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.psychology_outlined, color: Color(0xFF065643)),
                                              const SizedBox(width: 12),
                                              Text(
                                                "Aakaa AI Diagnostic",
                                                style: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: const Color(0xFF065643),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: isFreemium 
                                                  ? Colors.amberAccent.withValues(alpha: 0.2)
                                                  : (isBasic ? const Color(0xFF065643).withValues(alpha: 0.1) : const Color(0xFF80DEEA).withValues(alpha: 0.15)),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              isFreemium 
                                                  ? "🔒 Gated" 
                                                  : (isBasic ? "4/5 Credits" : "Pro ♾️ Active"),
                                              style: GoogleFonts.outfit(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: isFreemium ? Colors.black87 : const Color(0xFF065643),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Divider(color: Colors.grey[100]),
                                      const SizedBox(height: 16),

                                      // Sentiment Badge
                                      Text(
                                        "Sentiment Spectrum",
                                        style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: _sentimentColor.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          _detectedSentiment,
                                          style: GoogleFonts.outfit(
                                            color: _sentimentColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      // Cognitive Distortion Field
                                      Text(
                                        "Cognitive Distortion Trap",
                                        style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _detectedDistortion,
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF065643),
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      // Breakthrough Advice
                                      Text(
                                        "Breakthrough Perspective",
                                        style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _breakthroughAdvice,
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          height: 1.5,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // The Glassmorphic Blur Blockade for Freemium Users
                                if (isFreemium)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                        child: Container(
                                          color: Colors.white.withValues(alpha: 0.4),
                                          padding: const EdgeInsets.all(28),
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF065643).withValues(alpha: 0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.lock_rounded, color: Color(0xFF065643), size: 32),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                "AI Wave Analysis Locked",
                                                style: GoogleFonts.outfit(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(0xFF065643),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "Discover cognitive distortion loops & track mental sentiment maps in real-time.",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 13,
                                                  color: Colors.grey[800],
                                                  height: 1.4,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (_) => const ClientSubscription()),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFF065643),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                ),
                                                child: Text(
                                                  "Unlock AI Analytics (₹199)",
                                                  style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            
                            const SizedBox(height: 48),

                            // Return Home Button
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF065643),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                ),
                                child: Text(
                                  "Tranquil Completion",
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 60),
                          ],
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
