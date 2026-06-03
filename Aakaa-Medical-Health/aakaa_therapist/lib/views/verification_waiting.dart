import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';
import 'therapist_login.dart';

class VerificationWaiting extends StatefulWidget {
  final String doctorName;
  final String licenseId;

  const VerificationWaiting({
    super.key,
    required this.doctorName,
    required this.licenseId,
  });

  @override
  State<VerificationWaiting> createState() => _VerificationWaitingState();
}

class _VerificationWaitingState extends State<VerificationWaiting> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Soothing slow pulse animation for administrative waiting room
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    HapticFeedback.heavyImpact();
    
    // Clear professional session and return to clean login root
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TherapistLogin()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Lock Heartbeat Aura Visual
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0A7D62).withValues(alpha: 0.05),
                      border: Border.all(
                        color: const Color(0xFF0A7D62).withValues(alpha: 0.15),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0A7D62).withValues(alpha: 0.08),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: Color(0xFF0A7D62), // Soothing therapeutic green
                        size: 48,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Welcome Header
                Text(
                  "Credentials Pending",
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065643),
                  ),
                ),
                
                const SizedBox(height: 8),

                Text(
                  "Verification Protocol Active",
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0A7D62),
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 40),

                // Glassmorphic Verification Detail Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: const Color(0xFF065643).withValues(alpha: 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF065643).withValues(alpha: 0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF065643).withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.badge_outlined, size: 20, color: Color(0xFF065643)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Clinical Lead",
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF065643).withValues(alpha: 0.4),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.doctorName,
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF065643),
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF065643).withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.vpn_key_outlined, size: 20, color: Color(0xFF065643)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "State License Registration ID",
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF065643).withValues(alpha: 0.4),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.licenseId,
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF065643),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFFFF7F5), height: 1),
                      const SizedBox(height: 16),
                      Text(
                        "Our clinical board is verifying your medical credentials. This usually takes less than 24 hours.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF065643).withValues(alpha: 0.7),
                          fontSize: 12.5,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFFFF7F5), height: 1),
                      const SizedBox(height: 16),
                      Text(
                        "This standard verification buffer takes up to 24 hours. We will email you immediately once your account turns 'Approved'.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF065643).withValues(alpha: 0.5),
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Logout / Exit Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF065643),
                    side: BorderSide(color: const Color(0xFF065643).withValues(alpha: 0.15)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: Text(
                    "Exit Portal",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  onPressed: _handleLogout,
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
