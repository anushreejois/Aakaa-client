import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/views/clientsubscription.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';
import 'package:psychologyapp_login/controllers/plan_controller.dart';

class ClientPlan extends StatefulWidget {
  const ClientPlan({super.key});

  @override
  State<ClientPlan> createState() => _ClientPlanState();
}

class _ClientPlanState extends State<ClientPlan>{
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
                  "My Plan",
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
                child: ValueListenableBuilder<int>(
                  valueListenable: PlanController.planIndexNotifier,
                  builder: (context, planIndex, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildActivePlanCard(planIndex),
                        const SizedBox(height: 40),
                        Text(
                          "What's included",
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF065643),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._getIncludedBenefits(planIndex).map((b) => _buildBenefitItem(b.icon, b.text)),
                        
                        if (planIndex < 3) ...[
                          const SizedBox(height: 32),
                          Text(
                            "Locked Features",
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._getLockedBenefits(planIndex).map((text) => _buildLockedItem(text)),
                          const SizedBox(height: 48),
                          _buildUpgradeButton(context),
                        ],
                        const SizedBox(height: 120),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlanCard(int planIndex) {
    bool isPremium = planIndex > 0;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isPremium ? const Color(0xFF065643) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  PlanController.currentPlan,
                  style: GoogleFonts.outfit(
                    color: isPremium ? Colors.white : const Color(0xFF065643),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPremium ? Colors.white : const Color(0xFF065643),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "ACTIVE",
                    style: GoogleFonts.outfit(
                      color: isPremium ? const Color(0xFF065643) : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _getPlanDescription(planIndex),
              style: GoogleFonts.outfit(
                color: isPremium ? Colors.white.withValues(alpha: 0.8) : Colors.grey[600],
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPlanDescription(int index) {
    switch (index) {
      case 0: return "Experience the essentials of daily mental wellness at no cost.";
      case 1: return "Master your emotional habits with unlimited analytics & soundscapes.";
      case 2: return "Unlock complete guided care with AI coaching & direct doctor messaging.";
      case 3: return "Experience complete VIP care with dedicated doctor check-ins & priority support.";
      default: return "";
    }
  }

  List<_Benefit> _getIncludedBenefits(int index) {
    List<_Benefit> benefits = [
      _Benefit(Icons.person_outline_rounded, "Basic profile setup"),
      _Benefit(Icons.auto_awesome_outlined, "Daily affirmations & breathing"),
      _Benefit(Icons.search_rounded, "Explore therapist directory"),
    ];

    if (index >= 0) {
      benefits.add(_Benefit(Icons.analytics_outlined, index == 0 ? "7-day mood history" : "Unlimited mood & sleep analytics"));
    }
    if (index >= 1) {
      benefits.add(_Benefit(Icons.spa_outlined, "Full audio sleep sanctuaries"));
      benefits.add(_Benefit(Icons.psychology_outlined, index == 1 ? "5 AI journal analyses / mo" : "Unlimited AI clinical coach"));
    }
    if (index >= 2) {
      benefits.add(_Benefit(Icons.chat_bubble_outline_rounded, "Direct doctor text messaging"));
      benefits.add(_Benefit(Icons.picture_as_pdf_outlined, index == 2 ? "Monthly psychological PDF reports" : "Weekly certified clinical reports"));
      benefits.add(_Benefit(Icons.discount_outlined, "10% off live video sessions"));
    }
    if (index >= 3) {
      benefits.add(_Benefit(Icons.handshake_outlined, "Dedicated matched therapist"));
      benefits.add(_Benefit(Icons.timer_outlined, "Priority 3h doctor response"));
      benefits.add(_Benefit(Icons.video_call_outlined, "1 Free 30-min check-in / mo"));
      benefits.add(_Benefit(Icons.headset_mic_outlined, "Emergency grounding audio line"));
    }
    return benefits;
  }

  List<String> _getLockedBenefits(int index) {
    if (index == 0) {
      return [
        "Unlimited mood & sleep analytics",
        "Full audio sleep sanctuaries",
        "AI clinical journal analyses",
        "Direct doctor text messaging",
        "Downloadable clinical reports",
      ];
    } else if (index == 1) {
      return [
        "Unlimited AI clinical coach",
        "Direct doctor text messaging",
        "Downloadable clinical reports",
        "1 Free 30-min live check-in / mo",
      ];
    } else if (index == 2) {
      return [
        "Dedicated matched therapist",
        "Priority 3h doctor response",
        "Weekly certified clinical reports",
        "1 Free 30-min live check-in / mo",
      ];
    }
    return [];
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF065643).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF065643), size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: const Color(0xFF065643),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded, color: Colors.grey[400], size: 18),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.outfit(
                fontSize: 15,
                color: Colors.grey[400],
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ClientSubscription()),
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
          "Upgrade Your Plan",
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

class _Benefit {
  final IconData icon;
  final String text;
  _Benefit(this.icon, this.text);
}
