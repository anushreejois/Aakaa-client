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
        // Base Warm Cream Daylight Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF7F5), Color(0xFFFFEFEA), Color(0xFFFFF7F5)],
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
                    color: const Color(0xFF065643).withValues(alpha: 0.08),
                    size: 350,
                    top: -50,
                    right: -100,
                  ),
                  _buildOrb(
                    offset: Offset(
                      40 * cos(_controller.value * 2 * pi),
                      20 * sin(_controller.value * 2 * pi),
                    ),
                    color: const Color(0xFFFF7A59).withValues(alpha: 0.10),
                    size: 300,
                    bottom: 100,
                    left: -80,
                  ),
                  _buildOrb(
                    offset: Offset(
                      25 * sin(_controller.value * 2 * pi + pi),
                      35 * cos(_controller.value * 2 * pi + pi),
                    ),
                    color: const Color(0xFF0A7D62).withValues(alpha: 0.06),
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
              color: color.withValues(alpha: min(1.0, color.a * 2)),
              blurRadius: 100,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
