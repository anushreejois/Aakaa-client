import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/controllers/passwordresetemail.dart';
import 'package:psychologyapp_login/views/clientforpasemailconfirmation.dart';

class ClientForgotPassword extends StatefulWidget {
  const ClientForgotPassword({super.key});

  @override
  State<ClientForgotPassword> createState() => _ClientForgotPasswordState();
}

class _ClientForgotPasswordState extends State<ClientForgotPassword>{
  final _clientForgotPasswordkey = GlobalKey<FormState>();
  final emailController = TextEditingController();

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
                      const SizedBox(width: 16),
                      Text(
                        "Forgot Password",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
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
                      child: Form(
                        key: _clientForgotPasswordkey,
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            
                            // Icon
                            Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 40,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.lock_reset_rounded,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                            
                            const SizedBox(height: 60),
                            
                            Text(
                              "Reset Password",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Enter your registered email and we'll send you a link to reset your password.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                                height: 1.6,
                              ),
                            ),
                            
                            const SizedBox(height: 60),
                            
                            // Email Input
                            _buildEmailField(),
                            
                            const SizedBox(height: 80),
                            
                            // Action Button
                            _buildConfirmButton(context),
                            
                            const SizedBox(height: 60),
                          ],
                        ),
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

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextFormField(
        controller: emailController,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: const Color(0xFF065643)),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter your email';
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Valid email required';
          return null;
        },
        decoration: InputDecoration(
          labelText: "Email Address",
          labelStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withOpacity(0.5)),
          prefixIcon: Icon(Icons.email_outlined, color: const Color(0xFF065643).withOpacity(0.6), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: () async {
          if(_clientForgotPasswordkey.currentState!.validate()){
            _showLoadingDialog(context);
            
            final normalizedemail = emailController.text.toLowerCase();
            final query = await FirebaseFirestore.instance.collection('Users').where('Identifier', isEqualTo: normalizedemail).limit(1).get();
            
            if(query.docs.isNotEmpty){
              final success = await PasswordResetEmailController().sendResetEmail(emailController.text);
              Navigator.pop(context); // Pop loading
              
              if(success == 'OK' ){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientForPasEmailVerification(email: emailController.text),
                  ),
                );
              } else {
                _showSnackBar(context, 'Reset link failed. Please try again.');
              }
            } else {
              Navigator.pop(context); // Pop loading
              _showSnackBar(context, 'Email not found. Please sign up.');
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF065643),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          elevation: 0,
        ),
        child: Text(
          "Send Reset Link",
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
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
              const SizedBox(height: 24),
              Text(
                "Checking records...",
                style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.outfit()),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
