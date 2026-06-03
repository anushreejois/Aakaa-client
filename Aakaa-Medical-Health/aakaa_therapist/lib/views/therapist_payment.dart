import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/zen_background.dart';
import 'verification_waiting.dart';
import 'therapist_login.dart';

class TherapistPayment extends StatefulWidget {
  final String doctorName;
  final String email;

  const TherapistPayment({
    super.key,
    required this.doctorName,
    required this.email,
  });

  @override
  State<TherapistPayment> createState() => _TherapistPaymentState();
}

class _TherapistPaymentState extends State<TherapistPayment> {
  bool _isProcessing = false;
  static const String backendUrl = "http://10.0.2.2:5000";

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    HapticFeedback.mediumImpact();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null) {
        _showError("Authentication session expired. Please log in again.");
        _navigateToLogin();
        return;
      }

      // Simulate payment delay
      await Future.delayed(const Duration(seconds: 2));

      final url = Uri.parse("$backendUrl/api/therapist/confirm-payment");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == "success") {
        HapticFeedback.heavyImpact();
        
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationWaiting(
              doctorName: widget.doctorName,
              licenseId: "Awaiting Document Review",
            ),
          ),
        );
      } else {
        _showError(data["message"] ?? "Payment verification failed.");
      }
    } catch (e) {
      _showError("Connection failed. Please ensure the backend is running.");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TherapistLogin()),
      (route) => false,
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
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
              children: [
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                    onPressed: _navigateToLogin,
                  ),
                ),
                const Spacer(),
                
                // Credit Card visual overlay
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF065643).withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "AAKAA CAREGIVER MEMBERSHIP",
                            style: GoogleFonts.outfit(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const Icon(Icons.verified_rounded, color: Colors.white, size: 24),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "₹999",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "One-Time Credential Verification Fee",
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Strategic Monetization Hook Details
                Text(
                  "Risk-Free Onboarding Hook",
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065643),
                  ),
                ),
                const SizedBox(height: 16),

                _buildHookBenefit(
                  Icons.assignment_turned_in_outlined,
                  "100% Refund Guarantee",
                  "If our clinical board rejects your medical credentials, your ₹999 fee is automatically refunded back to your source account.",
                ),
                const SizedBox(height: 16),
                _buildHookBenefit(
                  Icons.monetization_on_outlined,
                  "0% Platform Commission Waiver",
                  "To offset onboarding friction, Aakaa waives its 20% commission on your first 2 sessions. Earn your application fee back immediately!",
                ),

                const Spacer(),

                // Secure Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF065643),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 0,
                    ),
                    child: _isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Pay ₹999 & Submit Application",
                            style: GoogleFonts.outfit(fontSize: 16.5, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHookBenefit(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0A7D62), size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: const Color(0xFF065643),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    color: const Color(0xFF065643).withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
