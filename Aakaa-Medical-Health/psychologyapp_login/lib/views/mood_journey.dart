import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/activity_controller.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';

class MoodJourney extends StatelessWidget {
  const MoodJourney({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZenBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
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
                  "Mood Journey",
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
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInsightsCard(),
                    const SizedBox(height: 32),
                    Text(
                      "Weekly Trends",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMoodChart(),
                    const SizedBox(height: 40),
                    Text(
                      "Recent Check-ins",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMoodHistoryList(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 40),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're doing great!",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF065643),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You've maintained a 'Great' mood for 3 days. Your consistency is showing progress.",
                  style: GoogleFonts.outfit(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodChart() {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: ActivityController.moodHistoryNotifier,
      builder: (context, history, child) {
        return Container(
          height: 220,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: history.map((m) {
              double heightFactor = (m['value'] + 1) / 5; 
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 30,
                    height: 120 * heightFactor,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF065643).withValues(alpha: 0.6),
                          const Color(0xFF065643).withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    m['day'],
                    style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildMoodHistoryList() {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: ActivityController.moodHistoryNotifier,
      builder: (context, history, child) {
        final reversed = List<Map<String, dynamic>>.from(history).reversed.toList();
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reversed.length > 4 ? 4 : reversed.length,
          itemBuilder: (context, index) {
            final item = reversed[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.06)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF065643).withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_rounded, color: Color(0xFF065643), size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Felt ${item['mood']}",
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF065643)),
                        ),
                        Text(
                          item['time'] ?? "Today, 10:30 AM",
                          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey[400]),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
