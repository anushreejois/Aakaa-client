import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/zen_background.dart';
import 'therapist_signup.dart';
import 'therapist_payment.dart';
import 'verification_waiting.dart';
import 'therapist_home.dart';

class TherapistLogin extends StatefulWidget {
  const TherapistLogin({super.key});

  @override
  State<TherapistLogin> createState() => _TherapistLoginState();
}

class _TherapistLoginState extends State<TherapistLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const String backendUrl = "http://10.0.2.2:5000"; // Localhost loopback for emulator

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    HapticFeedback.mediumImpact();
    _showLoadingDialog();

    try {
      final url = Uri.parse("$backendUrl/api/auth/login");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": _emailController.text.trim().toLowerCase(),
          "password": _passwordController.text,
        }),
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = data["user"];
        final String role = user["role"] ?? "client";

        // Gatekeeping: Verify user is registered as a Therapist
        if (role != "therapist") {
          HapticFeedback.heavyImpact();
          _showErrorSnackBar("Access Denied: Regular client credentials cannot access Caregiver Portal.");
          return;
        }

        HapticFeedback.mediumImpact();

        // Stash auth tokens inside shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", data["token"]);
        await prefs.setString("auth_role", role);
        await prefs.setString("auth_email", user["email"]);

        final String verificationStatus = user["verificationStatus"] ?? "pending";
        final bool hasPaidMembershipFee = user["hasPaidMembershipFee"] ?? false;
        final String doctorName = user["fullName"] ?? "Therapist";

        if (!mounted) return;

        if (!hasPaidMembershipFee) {
          // Route to Onboarding Payment gateway simulator
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TherapistPayment(
                doctorName: "Dr. $doctorName",
                email: user["email"],
              ),
            ),
          );
        } else if (verificationStatus == "pending" || verificationStatus == "rejected") {
          // Send to locked waiting room
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationWaiting(
                doctorName: "Dr. $doctorName",
                licenseId: "Awaiting Document Review",
              ),
            ),
          );
        } else {
          // Approved! Route to Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TherapistHome(
                doctorName: "Dr. $doctorName",
              ),
            ),
          );
        }
      } else {
        HapticFeedback.heavyImpact();
        _showErrorSnackBar(data["message"] ?? "Invalid login credentials.");
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      _showErrorSnackBar("Backend connection error. Please verify server status.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZenBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF065643).withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1)),
                      ),
                      child: const Icon(Icons.medical_services_rounded, size: 60, color: Color(0xFF065643)),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    Text(
                      "Welcome Back",
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      "Therapist Companion Portal",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 60),

                    _buildTextField(
                      controller: _emailController,
                      hint: "Professional Email",
                      icon: Icons.email_outlined,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Email is required";
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!emailRegex.hasMatch(v.trim())) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildTextField(
                      controller: _passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      onPasswordToggle: () => setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      }),
                      validator: (v) => v!.length < 6 ? "Min 6 characters" : null,
                    ),

                    const SizedBox(height: 40),

                    _buildActionButton(),

                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Apply to join clinical staff? ",
                          style: GoogleFonts.outfit(color: Colors.grey[600]),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TherapistSignup()),
                            );
                          },
                          child: Text(
                            "Register",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF065643),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onPasswordToggle,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        validator: validator,
        style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.4)),
          prefixIcon: Icon(icon, color: const Color(0xFF065643).withValues(alpha: 0.6)),
          suffixIcon: isPassword ? IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: const Color(0xFF065643).withValues(alpha: 0.4),
            ),
            onPressed: onPasswordToggle,
          ) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: _submitLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF065643),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
        ),
        child: Text(
          "Verify & Login",
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF065643)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
