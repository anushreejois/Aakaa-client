import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';

class VentReleaseLounge extends StatefulWidget {
  const VentReleaseLounge({super.key});

  @override
  State<VentReleaseLounge> createState() => _VentReleaseLoungeState();
}

class _VentReleaseLoungeState extends State<VentReleaseLounge> {
  final TextEditingController _ventController = TextEditingController();
  bool _isVaporizing = false;
  double _opacity = 1.0;

  @override
  void dispose() {
    _ventController.dispose();
    super.dispose();
  }

  void _triggerVaporization(BuildContext context) {
    if (_ventController.text.trim().isEmpty) return;

    setState(() {
      _isVaporizing = true;
      _opacity = 0.0; // Cleanly fade out all elements
    });

    // Completely wipe content from memory and reset view after a peaceful fade transition
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _ventController.clear();
        _isVaporizing = false;
        _opacity = 1.0; // Fade back in cleanly
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Wiped completely from memory. Rest in peace.",
            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF0A7D62),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryTextColor = const Color(0xFF065643);
    Color secondaryTextColor = const Color(0xFF065643).withValues(alpha: 0.7);

    return Scaffold(
      body: ZenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                
                // Top navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Safe Vent Lounge",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryTextColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.security_rounded, color: Color(0xFF0A7D62), size: 20),
                    ),
                  ],
                ),

                const Spacer(flex: 1),

                // Prompt details
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 600),
                  child: Column(
                    children: [
                      Text(
                        "Silent Release",
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No history is kept. No databases will store this. Write your rawest frustration or sadness, then watch it dissolve cleanly into nothingness.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: secondaryTextColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Interactive Vent Box
                Expanded(
                  flex: 4,
                  child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(color: primaryTextColor.withValues(alpha: 0.08)),
                        boxShadow: [
                          BoxShadow(
                            color: primaryTextColor.withValues(alpha: 0.04),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _ventController,
                        maxLines: null,
                        expands: true,
                        enabled: !_isVaporizing,
                        style: GoogleFonts.outfit(
                          color: primaryTextColor,
                          fontSize: 16,
                          height: 1.6,
                        ),
                        decoration: InputDecoration(
                          hintText: "Scream here... Scold, vent, let out whatever is poisoning your peace.",
                          hintStyle: GoogleFonts.outfit(
                            color: primaryTextColor.withValues(alpha: 0.4),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Vaporize Action Button
                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: _isVaporizing ? null : () => _triggerVaporization(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF065643),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    child: _isVaporizing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "Wiping from memory...",
                                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          )
                        : Text(
                            "Release Into Light ✨",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
