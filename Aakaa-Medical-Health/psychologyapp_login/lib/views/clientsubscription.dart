import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientSubscription extends StatefulWidget {
  const ClientSubscription({super.key});

  @override
  State<ClientSubscription> createState() => _ClientSubscriptionState();
}

class _ClientSubscriptionState extends State<ClientSubscription> {
  int _selectedPlanIndex = 2; // Default to Premium

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
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  centerTitle: false,
                  title: Text(
                    "Subscription",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
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
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      _buildPlanCard(0, "Freemium", "🧪", "The essentials", "Free", [
                        "Basic profile setup",
                        "3-day mood tracking",
                        "Explore therapists",
                      ]),
                      const SizedBox(height: 16),
                      _buildPlanCard(1, "Basic", "🎯", "For starters", "₹499/mo", [
                        "Mood tracking + journal",
                        "5+ self-help tools",
                        "Limited therapist chat",
                        "Appointment access",
                      ]),
                      const SizedBox(height: 16),
                      _buildPlanCard(2, "Premium", "💎", "Best value", "₹999/mo", [
                        "Unlimited therapist chat",
                        "Full self-help library",
                        "AI mood insights",
                        "Session notes download",
                        "Priority booking",
                      ]),
                      const SizedBox(height: 16),
                      _buildPlanCard(3, "Platinum", "👑", "VIP care", "₹1999/mo", [
                        "Emergency support line",
                        "Dedicated therapist match",
                        "AI coach & habits",
                        "Weekly PDF reports",
                        "Personalized wellness plan",
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
        ],
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
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.15 : 0.05),
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
                        color: isSelected ? const Color(0xFF065643) : Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  price,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF065643) : Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: isSelected ? const Color(0xFF065643).withOpacity(0.7) : Colors.white.withOpacity(0.4),
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
                    color: isSelected ? const Color(0xFF065643).withOpacity(0.6) : Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    f,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isSelected ? const Color(0xFF065643).withOpacity(0.8) : Colors.white.withOpacity(0.7),
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

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "Confirm Selection",
          style: GoogleFonts.outfit(
            color: const Color(0xFF065643),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
