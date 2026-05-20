import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/controllers/otpgeneration.dart';
import "package:psychologyapp_login/views/clientlogin.dart";
import "package:psychologyapp_login/controllers/signup_loginfunctionality.dart";

class ClientEmailVerification extends StatefulWidget {
  final String email;
  final String password;
  const ClientEmailVerification({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<ClientEmailVerification> createState() =>
      _ClientEmailVerificationState();
}

class _ClientEmailVerificationState extends State<ClientEmailVerification> {
  final SignupLoginFunctionality signupFunctionality = SignupLoginFunctionality();
  final TextEditingController _firstDigit = TextEditingController();
  final TextEditingController _secondDigit = TextEditingController();
  final TextEditingController _thirdDigit = TextEditingController();
  final TextEditingController _fourthDigit = TextEditingController();

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
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: const Icon(Icons.mark_email_read_outlined, color: Colors.white, size: 60),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            "Verification",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Enter the code sent to",
                            style: GoogleFonts.outfit(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.email,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          
                          const SizedBox(height: 60),
                          
                          // OTP Inputs
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildOTPField(_firstDigit),
                              _buildOTPField(_secondDigit),
                              _buildOTPField(_thirdDigit),
                              _buildOTPField(_fourthDigit),
                            ],
                          ),

                          const SizedBox(height: 60),

                          Text(
                            "Didn't receive the code?",
                            style: GoogleFonts.outfit(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () async {
                              final success = await OTPGeneration.sendOTP(widget.email);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Code resent to ${widget.email}'),
                                    backgroundColor: const Color(0xFF0A7D62),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Resend Code",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          const SizedBox(height: 80),

                          // Verify Button
                          SizedBox(
                            width: double.infinity,
                            height: 65,
                            child: ElevatedButton(
                              onPressed: _handleVerify,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF065643),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                "Verify",
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPField(TextEditingController controller) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          cursorColor: Colors.white,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "-",
            hintStyle: TextStyle(color: const Color(0xFF065643).withValues(alpha: 0.3), fontSize: 24),
          ),
          style: GoogleFonts.outfit(
            color: const Color(0xFF065643),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          onChanged: (value) {
            if (value.isNotEmpty) {
              FocusScope.of(context).nextFocus();
            }
          },
        ),
      ),
    );
  }

  void _handleVerify() {
    String userEnteredOTP = _firstDigit.text + _secondDigit.text + _thirdDigit.text + _fourthDigit.text;
    bool verified = OTPGeneration.verifyOTP(userEnteredOTP);
    
    if (verified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account verified successfully!'),
          backgroundColor: Color(0xFF0A7D62),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ClientLogin()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid code. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
