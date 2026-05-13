import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlidingToggleButton extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onToggle;

  const SlidingToggleButton({
    super.key,
    required this.isLogin,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;

    return Container(
      width: width,
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF065643).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Sliding background indicator
          AnimatedAlign(
            alignment: isLogin
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutExpo,
            child: Container(
              width: (width - 8) / 2,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
    
          // The actual toggle texts
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      "Login",
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: isLogin ? FontWeight.bold : FontWeight.w500,
                        color: isLogin ? const Color(0xFF065643) : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: !isLogin ? FontWeight.bold : FontWeight.w500,
                        color: !isLogin ? const Color(0xFF065643) : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
