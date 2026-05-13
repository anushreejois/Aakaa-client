import 'dart:ui';
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:psychologyapp_login/controllers/signup_loginfunctionality.dart";
import "package:psychologyapp_login/controllers/togglebutton.dart";
import "package:psychologyapp_login/views/clientemailconfirmation.dart";
import "package:psychologyapp_login/views/clientforgotpassword.dart";
import "package:psychologyapp_login/controllers/otpgeneration.dart";
import "package:psychologyapp_login/views/clientnavigationbar.dart";

class ClientLogin extends StatefulWidget {
  const ClientLogin({super.key});

  @override
  State<ClientLogin> createState() => _ClientLoginState();
}

class _ClientLoginState extends State<ClientLogin> {
  final SignupLoginFunctionality signupFunctionality = SignupLoginFunctionality();
  bool isLogin = true;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool isLoginPasswordVisible = false;
  bool isSignUpPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  late String loginemail;
  late String loginpassword;
  final TextEditingController signinemail = TextEditingController();
  late String signinpassword;
  final TextEditingController signinconfirmpassword = TextEditingController();
  bool onTap = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF065643), Color(0xFF0A7D62), Color(0xFF065643)],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Back Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    // Profile Icon
                    Hero(
                      tag: 'auth_icon',
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.person_rounded, color: Colors.white, size: 60),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Main Login Card (Glassmorphic)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Text(
                              isLogin ? "Welcome Back" : "Create Account",
                              style: GoogleFonts.outfit(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isLogin 
                                ? "Breathe in. Sign in to continue." 
                                : "Join our community of healing",
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                            
                            SlidingToggleButton(
                              isLogin: isLogin,
                              onToggle: (value) {
                                setState(() {
                                  isLogin = value;
                                });
                              },
                            ),
                            
                            const SizedBox(height: 40),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: isLogin 
                                ? _buildLoginForm() 
                                : _buildSignupForm(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextFieldLabel("Email Address"),
          const SizedBox(height: 12),
          _buildTextField(
            onChanged: (value) => loginemail = value,
            hint: "Enter your email",
            icon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Valid email required';
              return null;
            },
          ),
          const SizedBox(height: 24),
          _buildTextFieldLabel("Password"),
          const SizedBox(height: 12),
          _buildTextField(
            onChanged: (value) => loginpassword = value,
            hint: "Enter your password",
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            isPasswordVisible: isLoginPasswordVisible,
            onPasswordToggle: () => setState(() => isLoginPasswordVisible = !isLoginPasswordVisible),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your password';
              return null;
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClientForgotPassword())),
                child: Text(
                  "Forgot password?",
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.8), 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton("Sign In", _handleLogin),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextFieldLabel("Email Address"),
          const SizedBox(height: 12),
          _buildTextField(
            controller: signinemail,
            hint: "Enter your email",
            icon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Valid email required';
              return null;
            },
          ),
          const SizedBox(height: 24),
          _buildTextFieldLabel("Create Password"),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _passwordController,
            onChanged: (value) => signinpassword = value,
            hint: "At least 6 characters",
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            isPasswordVisible: isSignUpPasswordVisible,
            onPasswordToggle: () => setState(() => isSignUpPasswordVisible = !isSignUpPasswordVisible),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Password required';
              if (value.length < 6) return 'Minimum 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 24),
          _buildTextFieldLabel("Confirm Password"),
          const SizedBox(height: 12),
          _buildTextField(
            controller: signinconfirmpassword,
            hint: "Repeat your password",
            icon: Icons.lock_reset_rounded,
            isPassword: true,
            isPasswordVisible: isConfirmPasswordVisible,
            onPasswordToggle: () => setState(() => isConfirmPasswordVisible = !isConfirmPasswordVisible),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please confirm password';
              if (value != _passwordController.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton("Create Account", _handleSignup),
        ],
      ),
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onPasswordToggle,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        obscureText: isPassword && !isPasswordVisible,
        validator: validator,
        style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withOpacity(0.5)),
          prefixIcon: Icon(icon, color: const Color(0xFF065643).withOpacity(0.7)),
          suffixIcon: isPassword ? IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: const Color(0xFF065643).withOpacity(0.6),
              size: 20,
            ),
            onPressed: onPasswordToggle,
          ) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF065643),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() => isLoading = true);
      _showLoadingDialog();
      
      String res = await signupFunctionality.loginUser(loginemail, loginpassword);
      Navigator.pop(context); // Pop loading dialog
      
      if (res == "Login successful") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClientNavigationBar(loginemail: loginemail)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res),
          backgroundColor: Colors.redAccent,
        ));
      }
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleSignup() async {
    if (_signUpFormKey.currentState!.validate()) {
      setState(() => isLoading = true);
      _showLoadingDialog();
      
      final result = await signupFunctionality.signUpUser(signinemail.text, signinconfirmpassword.text);
      if (result == "Success") {
        final success = await OTPGeneration.sendOTP(signinemail.text);
        Navigator.pop(context);
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ClientEmailVerification(
                email: signinemail.text,
                password: signinconfirmpassword.text,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send OTP.')));
        }
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result),
          backgroundColor: Colors.redAccent,
        ));
      }
      setState(() => isLoading = false);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF065643).withOpacity(0.9),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
              const SizedBox(height: 32),
              Text(
                "Breathe. Healing takes time...",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
