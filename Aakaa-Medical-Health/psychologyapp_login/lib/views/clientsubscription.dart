import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';
import 'package:psychologyapp_login/controllers/plan_controller.dart';
import 'package:psychologyapp_login/controllers/payment_service.dart';

class ClientSubscription extends StatefulWidget {
  const ClientSubscription({super.key});

  @override
  State<ClientSubscription> createState() => _ClientSubscriptionState();
}

class _ClientSubscriptionState extends State<ClientSubscription> {
  late int _selectedPlanIndex;

  @override
  void initState() {
    super.initState();
    _selectedPlanIndex = PlanController.currentPlanIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Subscription",
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
                      "Choose the plan that's right for you",
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    _buildPlanCard(0, "Freemium", "🧪", "Daily habit starter", "Free", [
                      "Basic daily mood logs & affirmations",
                      "Single sleep track (Midnight Rain)",
                      "Search therapist directory",
                    ]),
                    const SizedBox(height: 16),
                    _buildPlanCard(1, "Basic", "🎯", "The active companion", "₹199/mo", [
                      "Real-Time Active Caretaker check-ins",
                      "Safe Vent Lounge (Burn & Release)",
                      "Zen Sleep Mixer & customizable sliders",
                      "5 AI Journal analyses per month",
                      "Daily Caretaker push reminders",
                    ]),
                    const SizedBox(height: 16),
                    _buildPlanCard(2, "Standard", "⭐", "Guided care", "₹399/mo", [
                      "Everything in Basic (Unlimited)",
                      "Direct doctor text messaging",
                      "Therapist CBT Diagnostic sharing",
                      "Monthly Certified Progress PDF reports",
                      "10% off live video/audio sessions",
                    ]),
                    const SizedBox(height: 16),
                    _buildPlanCard(3, "Premium", "💎", "VIP clinical care", "₹799/mo", [
                      "Everything in Standard",
                      "1 Free 30-min live session / month",
                      "All Vent animations (Burn, Bubble, Cosmic)",
                      "24/7 Emergency Grounding Audio Line",
                      "Priority 3h doctor response & reports",
                    ]),
                    
                    const SizedBox(height: 48),
                    _buildContinueButton(),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(int index, String title, String emoji, String subtitle, String price, List<String> features) {
    bool isSelected = _selectedPlanIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPlanIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF065643) : Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? const Color(0xFF065643) : const Color(0xFF065643).withValues(alpha: 0.08),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.15 : 0.02),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF065643),
                      ),
                    ),
                  ],
                ),
                Text(
                  price,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF065643),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: isSelected ? Colors.white.withValues(alpha: 0.8) : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: isSelected ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF065643).withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    f,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.grey[800],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A7D62),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: () async {
        if (_selectedPlanIndex == 0) {
          PlanController.selectPlan(0);
          _showSuccessSnackBar("Successfully updated to Freemium Plan!");
          Navigator.pop(context);
          return;
        }

        double amount = 0.0;
        if (_selectedPlanIndex == 1) amount = 199.0;
        else if (_selectedPlanIndex == 2) amount = 399.0;
        else if (_selectedPlanIndex == 3) amount = 799.0;

        await PaymentService.startSubscriptionPayment(
          planIndex: _selectedPlanIndex,
          amount: amount,
          context: context,
          onComplete: () {
            _showSuccessSnackBar("Successfully upgraded to ${PlanController.currentPlan} Plan! 🌟");
            Navigator.pop(context);
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFF065643),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "Confirm Selection",
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
