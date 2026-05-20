import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';

class ReportAProblem extends StatefulWidget {
  const ReportAProblem({super.key});

  @override
  State<ReportAProblem> createState() => _ReportAProblemState();
}

class _ReportAProblemState extends State<ReportAProblem> {
  final _messageController = TextEditingController();
  String _selectedCategory = "Bug Report";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                centerTitle: false,
                title: Text(
                  "Report a Problem",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF065643),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Tell us what's wrong and we'll look into it.",
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: const Color(0xFF065643).withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    _buildSectionLabel("Category"),
                    const SizedBox(height: 12),
                    _buildCategoryDropdown(),
                    
                    const SizedBox(height: 32),
                    
                    _buildSectionLabel("Description"),
                    const SizedBox(height: 12),
                    _buildMessageField(),
                    
                    const SizedBox(height: 48),
                    
                    _buildSubmitButton(),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF065643).withValues(alpha: 0.6),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF065643)),
          style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.w600, fontSize: 16),
          items: ["Bug Report", "UI Issue", "Account Issue", "Feature Request", "Other"]
            .map((String value) => DropdownMenuItem(value: value, child: Text(value)))
            .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _selectedCategory = value);
          },
        ),
      ),
    );
  }

  Widget _buildMessageField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: _messageController,
        maxLines: 6,
        style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "Tell us more details...",
          hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.4)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF065643), Color(0xFF0A7D62)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Thank you! Your report has been submitted.", style: GoogleFonts.outfit(color: Colors.white)),
              backgroundColor: const Color(0xFF065643),
            ),
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: Text(
          "Submit Report",
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
