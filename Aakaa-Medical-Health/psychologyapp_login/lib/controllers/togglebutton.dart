import 'package:flutter/material.dart';

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
    double width = MediaQuery.of(context).size.width * 0.75;

    return Container(
      width: width,
      height: 75,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F7),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: const Color(0xFF3E64FF).withOpacity(0.4),
            blurRadius: 11,
            spreadRadius: 3,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Sliding background indicator
          AnimatedAlign(
            alignment: isLogin
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              width: (width - 12) / 2,
              height: 58,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Color(0xFF6B779A).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
    
          // The actual toggle texts
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(true),
                  child: Center(
                    child: Text(
                      "Log-in",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: isLogin
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggle(false),
                  child: Center(
                    child: Text(
                      "Sign-up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: !isLogin
                            ? Colors.black
                            : Colors.grey[600],
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