import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/zen_background.dart';
import 'therapist_login.dart';

class TherapistSignup extends StatefulWidget {
  const TherapistSignup({super.key});

  @override
  State<TherapistSignup> createState() => _TherapistSignupState();
}

class _TherapistSignupState extends State<TherapistSignup> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _licenseController = TextEditingController();
  final _passwordController = TextEditingController();

  static const String backendUrl = "http://10.0.2.2:5000"; // Loopback for emulator local testing

  bool _isPasswordVisible = false;
  String? _uploadedFileName; // Track uploaded credential file
  final List<String> _selectedSpecialties = [];

  final List<String> _allSpecialties = [
    "CBT",
    "Trauma & PTSD",
    "Anxiety & Depression",
    "Grief Support",
    "ADHD",
    "Couples Therapy",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _licenseController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Simulates uploading state picker
  void _pickMockLicense() async {
    HapticFeedback.lightImpact();
    setState(() {
      _uploadedFileName = "medical_practice_license_${_nameController.text.trim().replaceAll(" ", "_").toLowerCase()}_verified.pdf";
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Credential document securely staged.",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF065643),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearMockLicense() {
    HapticFeedback.lightImpact();
    setState(() {
      _uploadedFileName = null;
    });
  }

  void _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    if (_uploadedFileName == null) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please upload your medical practice license certificate.",
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    _showLoadingDialog();

    try {
      final url = Uri.parse("$backendUrl/api/auth/therapist/register");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": _emailController.text.trim().toLowerCase(),
          "password": _passwordController.text,
          "fullName": _nameController.text.trim(),
          "licenseNumber": _licenseController.text.trim().toUpperCase(),
          "specialties": _selectedSpecialties,
          "licenseFileUrl": "http://aakaa.s3.aws.com/licenses/$_uploadedFileName"
        }),
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        HapticFeedback.mediumImpact();
        
        // Stash registration parameters for session caching
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_email", _emailController.text.trim().toLowerCase());
        
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Account registered successfully! Please log in to pay your onboarding fee.",
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF065643),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Route to login page so they authenticate and pay onboarding fee on login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const TherapistLogin(),
          ),
          (route) => false,
        );
      } else {
        HapticFeedback.heavyImpact();
        _showErrorSnackBar(data["message"] ?? "Registration failed.");
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      _showErrorSnackBar("Backend connection error. Please check server status.");
    }
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
                    const SizedBox(height: 30),
                    
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF065643).withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1)),
                      ),
                      child: const Icon(Icons.medical_services_rounded, size: 48, color: Color(0xFF065643)),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Text(
                      "Create Account",
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      "Register your clinical credentials",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 30),

                    _buildTextField(
                      controller: _nameController,
                      hint: "Full Name",
                      icon: Icons.person_outline_rounded,
                      validator: (v) => v!.isEmpty ? "Name required" : null,
                    ),
                    
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _licenseController,
                      hint: "Medical Registration ID",
                      icon: Icons.assignment_ind_outlined,
                      validator: (v) => v!.isEmpty ? "Registration license ID required" : null,
                    ),
                    
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _emailController,
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
                    
                    const SizedBox(height: 16),
                    
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

                    const SizedBox(height: 24),

                    // Specialties selector
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Practice Specialties",
                        style: GoogleFonts.outfit(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _allSpecialties.map((specialty) {
                        final isSelected = _selectedSpecialties.contains(specialty);
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              if (isSelected) {
                                _selectedSpecialties.remove(specialty);
                              } else {
                                _selectedSpecialties.add(specialty);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF065643) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF065643) : const Color(0xFF065643).withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              specialty,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : const Color(0xFF065643),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Document Upload Widget Card
                    _buildUploadCard(),

                    const SizedBox(height: 30),

                    _buildActionButton(),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.outfit(color: Colors.grey[600]),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF065643),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),

                    // Compliance Tag
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "By submitting, you represent that all licensure, academic, and degree credentials are legal, valid, and comply with HIPAA security regulations.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF065643).withValues(alpha: 0.4),
                          fontSize: 10,
                          height: 1.3,
                        ),
                      ),
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

  Widget _buildUploadCard() {
    final hasFile = _uploadedFileName != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF065643).withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Medical Practice License Certificate",
            style: GoogleFonts.outfit(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF065643),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: hasFile ? null : _pickMockLicense,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: hasFile ? const Color(0xFF065643).withValues(alpha: 0.03) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF065643).withValues(alpha: hasFile ? 0.15 : 0.3),
                  width: 1.5,
                  style: hasFile ? BorderStyle.solid : BorderStyle.none, // we simulate dashed card below
                ),
              ),
              child: hasFile
                  ? Row(
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF065643), size: 36),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _uploadedFileName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: const Color(0xFF065643),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Staged PDF • 1.2 MB",
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: const Color(0xFF065643).withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                          onPressed: _clearMockLicense,
                        ),
                      ],
                    )
                  : CustomPaint(
                      painter: _DashedBorderPainter(color: const Color(0xFF065643).withValues(alpha: 0.3)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 32,
                              color: const Color(0xFF065643).withValues(alpha: 0.6),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Click to upload practice license PDF",
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF065643).withValues(alpha: 0.6),
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
        onPressed: _submitRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF065643),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
        ),
        child: Text(
          "Apply for Staff",
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
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 5.0;

    // Draw top
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }

    // Draw bottom
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height), Offset(startX + dashWidth, size.height), paint);
      startX += dashWidth + dashSpace;
    }

    // Draw left
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }

    // Draw right
    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width, startY), Offset(size.width, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
