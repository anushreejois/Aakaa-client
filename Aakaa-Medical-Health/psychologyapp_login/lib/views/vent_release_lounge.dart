import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/controllers/plan_controller.dart';
import 'package:psychologyapp_login/views/premium_gate_dialog.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';

enum ParticleType { burn, bubble, cosmic }

class VentReleaseLounge extends StatefulWidget {
  const VentReleaseLounge({super.key});

  @override
  State<VentReleaseLounge> createState() => _VentReleaseLoungeState();
}

class _VentReleaseLoungeState extends State<VentReleaseLounge> with SingleTickerProviderStateMixin {
  final TextEditingController _ventController = TextEditingController();
  late Ticker _ticker;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();
  
  ParticleType _selectedType = ParticleType.burn;
  bool _isVaporizing = false;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      _updateParticles();
    });
    _ticker.start();
    _initializeAllowedAnimations();
  }

  void _initializeAllowedAnimations() {
    // Lock animation defaults based on subscription index
    int tier = PlanController.currentPlanIndex;
    if (tier == 1) {
      _selectedType = ParticleType.burn; // Basic
    } else if (tier == 2) {
      _selectedType = ParticleType.burn; // Standard
    } else if (tier >= 3) {
      _selectedType = ParticleType.burn; // Premium
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _ventController.dispose();
    super.dispose();
  }

  void _updateParticles() {
    if (!mounted) return;
    setState(() {
      for (int i = _particles.length - 1; i >= 0; i--) {
        final p = _particles[i];
        p.update();
        if (p.life <= 0) {
          _particles.removeAt(i);
        }
      }
    });
  }

  void _spawnParticles(Offset center) {
    int count = 100;
    if (_selectedType == ParticleType.bubble) count = 50; // Larger bubbles, fewer needed

    for (int i = 0; i < count; i++) {
      double angle = _random.nextDouble() * 2 * math.pi;
      double speed = _random.nextDouble() * 4.0 + 1.0;
      double size = _random.nextDouble() * 6.0 + 2.0;
      Color color;

      if (_selectedType == ParticleType.burn) {
        // Red, Orange, Gold Embers
        color = Color.lerp(
          const Color(0xFFFF5722),
          const Color(0xFFFFC107),
          _random.nextDouble(),
        )!.withValues(alpha: 0.8);
        size = _random.nextDouble() * 8.0 + 3.0;
      } else if (_selectedType == ParticleType.bubble) {
        // Water blue and aqua bubbles
        color = Colors.lightBlueAccent.withValues(alpha: 0.6);
        size = _random.nextDouble() * 15.0 + 6.0;
      } else {
        // Sparkling lilac/cyan stars
        color = Color.lerp(
          const Color(0xFFE040FB),
          const Color(0xFF00E5FF),
          _random.nextDouble(),
        )!.withValues(alpha: 0.9);
        size = _random.nextDouble() * 5.0 + 2.0;
      }

      _particles.add(Particle(
        x: center.dx,
        y: center.dy,
        vx: math.cos(angle) * speed,
        vy: _selectedType == ParticleType.burn 
            ? -_random.nextDouble() * 5.0 - 2.0 // embers float upward
            : math.sin(angle) * speed,
        size: size,
        color: color,
        life: 1.0,
        decay: 0.008 + _random.nextDouble() * 0.015,
        type: _selectedType,
      ));
    }
  }

  void _triggerVaporization(BuildContext context) {
    if (_ventController.text.trim().isEmpty) return;

    setState(() {
      _isVaporizing = true;
      _opacity = 0.0;
    });

    // Obtain screen dimensions
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height / 2 - 50);

    // Spawn rich particle streams
    _spawnParticles(center);

    // Simulate complete physical dissolution and wipe content cleanly from system memory
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      setState(() {
        _ventController.clear();
        _isVaporizing = false;
        _opacity = 1.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Wiped completely from memory. Rest in peace.",
            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF0A7D62),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      );
    });
  }

  bool _isAnimationUnlocked(ParticleType type) {
    int tier = PlanController.currentPlanIndex;
    if (type == ParticleType.burn) return true; // Unlocked for all Basic+ users
    if (type == ParticleType.bubble) return tier >= 2; // Standard and Premium
    if (type == ParticleType.cosmic) return tier >= 3; // Premium only
    return false;
  }

  void _selectAnimationType(ParticleType type) {
    if (_isAnimationUnlocked(type)) {
      setState(() => _selectedType = type);
    } else {
      String tierRequired = type == ParticleType.bubble ? "Standard" : "Premium";
      showDialog(
        context: context,
        builder: (_) => PremiumAccessDialog(featureName: "$tierRequired animation '$type'"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryTextColor = const Color(0xFF065643);
    Color secondaryTextColor = const Color(0xFF065643).withValues(alpha: 0.7);

    return Scaffold(
      body: ZenBackground(
        child: Stack(
          children: [
            // Elegant particle painter canvas layer
            Positioned.fill(
              child: CustomPaint(
                painter: ParticlePainter(_particles),
              ),
            ),
  
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    
                    // Top navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          "Safe Vent Lounge",
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryTextColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.security_rounded, color: Color(0xFF0A7D62), size: 20),
                        ),
                      ],
                    ),

                  const Spacer(flex: 1),

                  // Prompt details
                  AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      children: [
                        Text(
                          "Burn & Release",
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "No history is kept. No databases will store this. Write your rawest frustration or sadness, then watch it dissolve into empty air.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: secondaryTextColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Interactive Vent Box
                  Expanded(
                    flex: 4,
                    child: AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(color: primaryTextColor.withValues(alpha: 0.08)),
                          boxShadow: [
                            BoxShadow(
                              color: primaryTextColor.withValues(alpha: 0.04),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _ventController,
                          maxLines: null,
                          expands: true,
                          enabled: !_isVaporizing,
                          style: GoogleFonts.outfit(
                            color: primaryTextColor,
                            fontSize: 16,
                            height: 1.6,
                          ),
                          decoration: InputDecoration(
                            hintText: "Scream here... Scold, vent, let out whatever is poisoning your peace.",
                            hintStyle: GoogleFonts.outfit(
                              color: primaryTextColor.withValues(alpha: 0.4),
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Dissolve animation selector controls
                  AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: primaryTextColor.withValues(alpha: 0.05)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDissolveButton(ParticleType.burn, "🔥 Burn", "Basic+"),
                          _buildDissolveButton(ParticleType.bubble, "🫧 Bubble", "Standard+"),
                          _buildDissolveButton(ParticleType.cosmic, "🌌 Cosmic", "Premium"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Vaporize Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: _isVaporizing ? null : () => _triggerVaporization(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF065643),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        shadowColor: const Color(0xFF065643).withValues(alpha: 0.4),
                      ),
                      child: _isVaporizing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  "Vaporizing into atoms...",
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            )
                          : Text(
                              "Release Into Light ✨",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildDissolveButton(ParticleType type, String title, String tierRequired) {
    bool isSelected = _selectedType == type;
    bool isUnlocked = _isAnimationUnlocked(type);

    return Expanded(
      child: GestureDetector(
        onTap: () => _selectAnimationType(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFF065643) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: isSelected 
                      ? Colors.white 
                      : (isUnlocked ? Colors.grey[300] : Colors.grey[600]),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (!isUnlocked) ...[
                const SizedBox(height: 2),
                Text(
                  tierRequired,
                  style: GoogleFonts.outfit(
                    color: Colors.grey[700],
                    fontSize: 9,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class Particle {
  double x, y;
  double vx, vy;
  double size;
  Color color;
  double life;
  double decay;
  ParticleType type;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.life,
    required this.decay,
    required this.type,
  });

  void update() {
    x += vx;
    y += vy;
    
    if (type == ParticleType.burn) {
      // embers wiggle slightly side to side as they float up
      vx += (math.Random().nextDouble() - 0.5) * 0.4;
      vy -= 0.05; // accelerate upward
    } else if (type == ParticleType.bubble) {
      // bubbles float upward slower and shift gently
      vy -= 0.02;
      vx += (math.Random().nextDouble() - 0.5) * 0.2;
    } else {
      // cosmic stardust moves outwards and slows down slightly
      vx *= 0.98;
      vy *= 0.98;
    }

    life -= decay;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paintObj = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      paintObj.color = p.color.withValues(alpha: p.life);
      
      if (p.type == ParticleType.bubble) {
        // Draw bubble outlines for high fidelity bubble pop look
        paintObj.style = PaintingStyle.stroke;
        paintObj.strokeWidth = 1.5;
        canvas.drawCircle(Offset(p.x, p.y), p.size * p.life, paintObj);
        
        // draw bubble highlight dot
        final highlightPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white.withValues(alpha: p.life * 0.4);
        canvas.drawCircle(Offset(p.x - p.size * 0.3, p.y - p.size * 0.3), p.size * 0.15, highlightPaint);
      } else if (p.type == ParticleType.cosmic) {
        // Draw starry points
        paintObj.style = PaintingStyle.fill;
        canvas.drawCircle(Offset(p.x, p.y), p.size * p.life, paintObj);
      } else {
        // Draw embers
        paintObj.style = PaintingStyle.fill;
        canvas.drawCircle(Offset(p.x, p.y), p.size * p.life, paintObj);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
