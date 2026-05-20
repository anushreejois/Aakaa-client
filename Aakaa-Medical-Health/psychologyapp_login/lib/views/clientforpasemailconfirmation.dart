import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';

class ClientForPasEmailVerification extends StatefulWidget {
  final String email;
  const ClientForPasEmailVerification({
    super.key,
    required this.email,
  });

  @override
  State<ClientForPasEmailVerification> createState() =>
      _ClientForPasEmailVerificationState();
}

class _ClientForPasEmailVerificationState extends State<ClientForPasEmailVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643), size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Verify Email",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF065643),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
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
                        const SizedBox(height: 60),
                        
                        // Verification Icon
                        Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF065643).withValues(alpha: 0.2),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.mark_email_read_rounded,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: 60),
                        
                        Text(
                          "Check your inbox",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF065643),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              color: const Color(0xFF065643).withValues(alpha: 0.7),
                              height: 1.6,
                            ),
                            children: [
                              const TextSpan(text: "A verification email has been sent to\n"),
                              TextSpan(
                                text: widget.email,
                                style: const TextStyle(
                                  color: Color(0xFF065643),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: "\n\nPlease follow the link in the email to securely reset your password."),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 80),
                        
                        // Back to Login Button
                        _buildBackToLoginButton(context),
                        
                        const SizedBox(height: 32),
                        
                        // Resend Option
                        TextButton(
                          onPressed: () {
                            // Handle resend logic
                          },
                          child: Text(
                            "Didn't receive an email? Resend",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF065643),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF065643), Color(0xFF0A7D62)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          elevation: 0,
        ),
        child: Text(
          "Back to Login",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
