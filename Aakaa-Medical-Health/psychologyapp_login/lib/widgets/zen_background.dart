import 'dart:math';
import 'package:flutter/material.dart';

class ZenBackground extends StatefulWidget {
  final Widget? child;
  const ZenBackground({super.key, this.child});

  @override
  State<ZenBackground> createState() => _ZenBackgroundState();
}

class _ZenBackgroundState extends State<ZenBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Deep Green Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF065643), Color(0xFF0A7D62), Color(0xFF065643)],
            ),
          ),
        ),
        
        // Animated Orbs
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  _buildOrb(
                    offset: Offset(
                      20 * sin(_controller.value * 2 * pi),
                      30 * cos(_controller.value * 2 * pi),
                    ),
                    color: Colors.white.withOpacity(0.02),
                    size: 300,
                    top: -50,
                    right: -100,
                  ),
                  _buildOrb(
                    offset: Offset(
                      40 * cos(_controller.value * 2 * pi),
                      20 * sin(_controller.value * 2 * pi),
                    ),
                    color: Colors.white.withOpacity(0.03),
                    size: 250,
                    bottom: 100,
                    left: -80,
                  ),
                  _buildOrb(
                    offset: Offset(
                      25 * sin(_controller.value * 2 * pi + pi),
                      35 * cos(_controller.value * 2 * pi + pi),
                    ),
                    color: Colors.white.withOpacity(0.02),
                    size: 400,
                    top: 200,
                    right: 50,
                  ),
                ],
              );
            },
          ),
        ),
        
        // The Screen Content
        if (widget.child != null) widget.child!,
      ],
    );
  }

  Widget _buildOrb({
    required Offset offset,
    required Color color,
    required double size,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top != null ? top + offset.dy : null,
      bottom: bottom != null ? bottom + offset.dy : null,
      left: left != null ? left + offset.dx : null,
      right: right != null ? right + offset.dx : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(color.opacity * 2),
              blurRadius: 100,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
