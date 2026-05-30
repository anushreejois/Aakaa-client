import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:psychologyapp_login/controllers/signup_loginfunctionality.dart';
import 'package:psychologyapp_login/views/clientforgotpassword.dart';
import 'package:psychologyapp_login/views/clientnavigationbar.dart';
import 'package:psychologyapp_login/views/clientemailconfirmation.dart';
import 'package:psychologyapp_login/controllers/otpgeneration.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';
import 'package:psychologyapp_login/controllers/user_controller.dart';

class ClientLogin extends StatefulWidget {
  const ClientLogin({super.key});

  @override
  State<ClientLogin> createState() => _ClientLoginState();
}

class _ClientLoginState extends State<ClientLogin> {
  final _clientLoginKey = GlobalKey<FormState>();
  final SignupLoginFunctionality signupFunctionality = SignupLoginFunctionality();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupNameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isSignupPasswordVisible = false;
  bool _isLoginMode = true;

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
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
                key: _clientLoginKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    
                    // Logo/Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF065643).withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1)),
                      ),
                      child: const Icon(Icons.spa_rounded, size: 60, color: Color(0xFF065643)),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    Text(
                      _isLoginMode ? "Welcome Back" : "Create Account",
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      _isLoginMode 
                        ? "Your journey to mindfulness continues." 
                        : "Start your personalized mental health journey.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 60),

                    if (!_isLoginMode) ...[
                      _buildTextField(
                        controller: signupNameController,
                        hint: "Full Name",
                        icon: Icons.person_outline_rounded,
                        validator: (v) => v!.isEmpty ? "Name required" : null,
                      ),
                      const SizedBox(height: 20),
                    ],

                     _buildTextField(
                      controller: _isLoginMode ? emailController : signupEmailController,
                      hint: "Email Address",
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
                      controller: _isLoginMode ? passwordController : signupPasswordController,
                      hint: "Password",
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      isPasswordVisible: _isLoginMode ? _isPasswordVisible : _isSignupPasswordVisible,
                      onPasswordToggle: () => setState(() {
                        if (_isLoginMode) {
                          _isPasswordVisible = !_isPasswordVisible;
                        } else {
                          _isSignupPasswordVisible = !_isSignupPasswordVisible;
                        }
                      }),
                      validator: (v) => v!.length < 6 ? "Min 6 characters" : null,
                    ),

                    if (_isLoginMode)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientForgotPassword())),
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),

                    _buildActionButton(),
                    
                    _buildGoogleButton(),

                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLoginMode ? "Don't have an account? " : "Already have an account? ",
                          style: GoogleFonts.outfit(color: Colors.grey[600]),
                        ),
                        GestureDetector(
                          onTap: _toggleMode,
                          child: Text(
                            _isLoginMode ? "Sign Up" : "Login",
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
        onPressed: () async {
          if (_clientLoginKey.currentState!.validate()) {
            _showLoadingDialog();
            
            if (_isLoginMode) {
              final result = await signupFunctionality.loginUser(emailController.text, passwordController.text);
              Navigator.pop(context); // Close loading
              
              if (result == 'Login successful' || result == 'success') {
                UserController.updateEmail(emailController.text);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => ClientNavigationBar(email: emailController.text)),
                  (route) => false,
                );
              } else {
                _showErrorSnackBar(result);
              }
            } else {
              // ✉️ Send OTP Verification to Email before creating the database account
              final success = await OTPGeneration.sendOTP(signupEmailController.text);
              Navigator.pop(context); // Close loading
              
              if (success) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientEmailVerification(
                      email: signupEmailController.text,
                      password: signupPasswordController.text,
                      fullName: signupNameController.text.trim(),
                    ),
                  ),
                );
              } else {
                _showErrorSnackBar("Failed to send verification code. Please check your email.");
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF065643),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
        ),
        child: Text(
          _isLoginMode ? "Login" : "Sign Up",
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Divider(color: const Color(0xFF065643).withValues(alpha: 0.1))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "OR",
                style: GoogleFonts.outfit(
                  color: const Color(0xFF065643).withValues(alpha: 0.4),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Divider(color: const Color(0xFF065643).withValues(alpha: 0.1))),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 65,
          child: OutlinedButton(
            onPressed: () async {
              _showLoadingDialog();
              try {
                final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/auth/google-login");
                final response = await http.post(
                  url,
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "email": "google.wellness@gmail.com",
                    "fullName": "Google Wellness Member"
                  }),
                );

                final data = jsonDecode(response.body);
                Navigator.pop(context); // Close loading

                if (response.statusCode == 200 && data["status"] == "success") {
                  final token = data["token"];
                  final userData = data["user"];

                  // Save JWT token locally for persistent authentication
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString("auth_token", token);

                  // Update UserController
                  UserController.updateUserFromBackend(userData);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClientNavigationBar(email: userData["email"]),
                    ),
                    (route) => false,
                  );
                } else {
                  _showErrorSnackBar(data["message"] ?? "Google Sign-In failed.");
                }
              } catch (e) {
                Navigator.pop(context); // Close loading
                _showErrorSnackBar("Connection failed. Please ensure backend is running.");
              }
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: const Color(0xFF065643).withValues(alpha: 0.15)),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.g_mobiledata_rounded,
                  size: 32,
                  color: Color(0xFF065643),
                ),
                const SizedBox(width: 8),
                Text(
                  _isLoginMode ? "Continue with Google" : "Sign Up with Google",
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065643),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.outfit()),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.outfit()),
        backgroundColor: const Color(0xFF0A7D62),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
