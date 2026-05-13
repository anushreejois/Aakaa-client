import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'clientmysession.dart';
import 'mindfulness_timer.dart';
import 'reflective_journal.dart';
import 'gratitude_practice.dart';
import 'sleep_sanctuaries.dart';
import 'affirmation_deck.dart';
import '../controllers/activity_controller.dart';
import 'mood_journey.dart';

class ClientActivity extends StatefulWidget {
  const ClientActivity({super.key});

  @override
  State<ClientActivity> createState() => _ClientActivityState();
}

class _ClientActivityState extends State<ClientActivity> {
  int? _selectedMoodIndex;
  
  final List<Map<String, dynamic>> _moods = [
    {"label": "Terrible", "icon": Icons.sentiment_very_dissatisfied_rounded, "color": Colors.redAccent},
    {"label": "Poor", "icon": Icons.sentiment_dissatisfied_rounded, "color": Colors.orangeAccent},
    {"label": "Neutral", "icon": Icons.sentiment_neutral_rounded, "color": Colors.amberAccent},
    {"label": "Good", "icon": Icons.sentiment_satisfied_rounded, "color": Colors.lightGreenAccent},
    {"label": "Great", "icon": Icons.sentiment_very_satisfied_rounded, "color": Colors.cyanAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (Zen Theme)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF065643),
                  Color(0xFF0A7D62),
                  Color(0xFF065643),
                ],
              ),
            ),
          ),
          
          // Decorative Circles
          Positioned(
            top: -50,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Colors.white.withOpacity(0.03),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.white.withOpacity(0.03),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // AppBar
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  centerTitle: false,
                  title: Text(
                    "Activity Hub",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                automaticallyImplyLeading: false,
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      
                      // Glassmorphic Summary Card
                      _buildSummaryCard(),

                      const SizedBox(height: 32),
                      
                      _buildSectionHeader("How are you feeling?"),
                      const SizedBox(height: 16),
                      _buildInteractiveMoodPicker(),

                      const SizedBox(height: 32),
                      
                      _buildSectionHeader("Growth Journey"),
                      const SizedBox(height: 16),
                      _buildMilestonesCard(),

                      const SizedBox(height: 32),
                      
                      _buildSectionHeader("Mindful Practices"),
                      const SizedBox(height: 16),
                      _buildActivityTile(
                        Icons.self_improvement_rounded, 
                        "Daily Mindfulness",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MindfulnessTimer())),
                      ),
                      const SizedBox(height: 12),
                      _buildActivityTile(
                        Icons.edit_note_rounded, 
                        "Reflective Journal",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReflectiveJournal())),
                      ),
                      const SizedBox(height: 12),
                      _buildActivityTile(
                        Icons.volunteer_activism_rounded, 
                        "Gratitude Practice",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GratitudePractice())),
                      ),
                      const SizedBox(height: 12),
                      _buildActivityTile(
                        Icons.nights_stay_rounded, 
                        "Sleep Sanctuary",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SleepSanctuaries())),
                      ),
                      const SizedBox(height: 12),
                      _buildActivityTile(
                        Icons.style_rounded, 
                        "Affirmation Deck",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AffirmationDeck())),
                      ),
                      
                      const SizedBox(height: 120),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.9),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            Icons.event_available_rounded, 
            "Sessions", 
            ActivityController.sessionCount.toString(),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ClientMySession())),
          ),
          _buildVerticalDivider(),
          _buildSummaryItem(
            Icons.favorite_rounded, 
            "Mood Logs", 
            ActivityController.moodLogCount.toString(),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MoodJourney())),
          ),
          _buildVerticalDivider(),
          _buildSummaryItem(Icons.trending_up_rounded, "Growth", ActivityController.formattedGrowth),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.1),
    );
  }

  Widget _buildInteractiveMoodPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_moods.length, (index) {
              final mood = _moods[index];
              final isSelected = _selectedMoodIndex == index;
              
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedMoodIndex = index);
                  _showMoodConfirmation(mood['label']);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? mood['color'].withOpacity(0.15) : Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isSelected ? mood['color'].withOpacity(0.2) : Colors.transparent,
                        blurRadius: isSelected ? 10 : 0,
                        spreadRadius: isSelected ? 1 : 0,
                      )
                    ],
                  ),
                  child: Icon(
                    mood['icon'],
                    color: isSelected ? mood['color'] : Colors.white.withOpacity(0.3),
                    size: 28,
                  ),
                ),
              );
            }),
          ),
          if (_selectedMoodIndex != null) ...[
            const SizedBox(height: 20),
            Text(
              "Feeling ${_moods[_selectedMoodIndex!]['label']}",
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMoodConfirmation(String mood) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logged feeling $mood. Your journey is being tracked.", style: GoogleFonts.outfit()),
        backgroundColor: const Color(0xFF0A7D62),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildMilestonesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: ActivityController.milestones.map((m) {
          IconData icon;
          switch (m['icon']) {
            case 'stars': icon = Icons.stars_rounded; break;
            case 'verified': icon = Icons.verified_user_rounded; break;
            case 'self_improvement': icon = Icons.self_improvement_rounded; break;
            default: icon = Icons.workspace_premium_rounded;
          }
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildMilestoneItem(icon, m['title']!, m['date']!),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMilestoneItem(IconData icon, String title, String date) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF065643).withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF065643), size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: const Color(0xFF065643),
              ),
            ),
            Text(
              date,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityTile(IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white54),
        onTap: onTap ?? () {},
      ),
    );
  }
}
