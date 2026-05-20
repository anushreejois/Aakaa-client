import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/controllers/activity_controller.dart';
import 'package:psychologyapp_login/views/affirmation_deck.dart';
import 'package:psychologyapp_login/views/clientmysession.dart';
import 'package:psychologyapp_login/views/gratitude_practice.dart';
import 'package:psychologyapp_login/views/mindfulness_timer.dart';
import 'package:psychologyapp_login/views/mood_journey.dart';
import 'package:psychologyapp_login/views/reflective_journal.dart';
import 'package:psychologyapp_login/views/sleep_sanctuaries.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';

class ClientActivity extends StatefulWidget {
  const ClientActivity({super.key});

  @override
  State<ClientActivity> createState() => _ClientActivityState();
}

class _ClientActivityState extends State<ClientActivity> {
  int? _selectedMoodIndex;

  final List<Map<String, dynamic>> _moods = [
    {"label": "Terrible", "icon": Icons.sentiment_very_dissatisfied_rounded, "color": const Color(0xFFFF4B4B)},
    {"label": "Bad", "icon": Icons.sentiment_dissatisfied_rounded, "color": const Color(0xFFFF8A00)},
    {"label": "Okay", "icon": Icons.sentiment_neutral_rounded, "color": const Color(0xFFFFC700)},
    {"label": "Good", "icon": Icons.sentiment_satisfied_rounded, "color": const Color(0xFF00C853)},
    {"label": "Great", "icon": Icons.sentiment_very_satisfied_rounded, "color": const Color(0xFF0A7D62)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZenBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                centerTitle: false,
                title: Text(
                  "Activity Hub",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF065643),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
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
                    _buildSectionHeader("Recent Reflections"),
                    const SizedBox(height: 16),
                    _buildRecentReflectionsCard(),
                    const SizedBox(height: 32),
                    _buildSectionHeader("Mindful Practices"),
                    const SizedBox(height: 16),
                    _buildActivityTile(Icons.self_improvement_rounded, "Daily Mindfulness", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MindfulnessTimer()))),
                    const SizedBox(height: 12),
                    _buildActivityTile(Icons.edit_note_rounded, "Reflective Journal", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReflectiveJournal()))),
                    const SizedBox(height: 12),
                    _buildActivityTile(Icons.volunteer_activism_rounded, "Gratitude Practice", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GratitudePractice()))),
                    const SizedBox(height: 12),
                    _buildActivityTile(Icons.nights_stay_rounded, "Sleep Sanctuary", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SleepSanctuaries()))),
                    const SizedBox(height: 12),
                    _buildActivityTile(Icons.style_rounded, "Affirmation Deck", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AffirmationDeck()))),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF065643),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSummaryCard() {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: ActivityController.moodHistoryNotifier,
      builder: (context, history, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(Icons.event_available_rounded, "Sessions", ActivityController.sessionCount.toString(), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ClientMySession()))),
              _buildVerticalDivider(),
              _buildSummaryItem(Icons.favorite_rounded, "Mood Logs", ActivityController.moodLogCount.toString(), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MoodJourney()))),
              _buildVerticalDivider(),
              _buildSummaryItem(Icons.trending_up_rounded, "Growth", ActivityController.formattedGrowth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF065643).withValues(alpha: 0.6), size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF065643)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 25, width: 1, color: Colors.grey[200]);
  }

  Widget _buildInteractiveMoodPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
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
                  ActivityController.logMood(index, mood['label']);
                  _showMoodConfirmation(mood['label']);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? mood['color'].withValues(alpha: 0.1) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    mood['icon'],
                    color: isSelected ? mood['color'] : Colors.grey[300],
                    size: 24,
                  ),
                ),
              );
            }),
          ),
          if (_selectedMoodIndex != null) ...[
            const SizedBox(height: 16),
            Text(
              "Feeling ${_moods[_selectedMoodIndex!]['label']}",
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF065643)),
            ),
          ],
        ],
      ),
    );
  }

  void _showMoodConfirmation(String mood) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logged feeling $mood.", style: GoogleFonts.outfit(color: Colors.white)),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
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
        Icon(icon, color: const Color(0xFF065643).withValues(alpha: 0.8), size: 18),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF065643)),
            ),
            Text(
              date,
              style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentReflectionsCard() {
    return ValueListenableBuilder<List<Map<String, String>>>(
      valueListenable: ActivityController.journalEntriesNotifier,
      builder: (context, journals, child) {
        return ValueListenableBuilder<List<String>>(
          valueListenable: ActivityController.gratitudeNotesNotifier,
          builder: (context, gratitudes, child) {
            final latestJournal = journals.isNotEmpty ? journals.first : null;
            final latestGratitude = gratitudes.isNotEmpty ? gratitudes.first : null;

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (latestJournal != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.edit_note_rounded, color: Color(0xFF0A7D62), size: 20),
                        const SizedBox(width: 12),
                        Text("Latest Journal", style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
                        const Spacer(),
                        Text(latestJournal['date'] ?? '', style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[400])),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      latestJournal['content'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600], height: 1.4),
                    ),
                    if (latestGratitude != null) ...[
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[100]),
                      const SizedBox(height: 16),
                    ],
                  ],
                  if (latestGratitude != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.volunteer_activism_rounded, color: Color(0xFF0A7D62), size: 20),
                        const SizedBox(width: 12),
                        Text("Recent Gratitude", style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"$latestGratitude"',
                      style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic),
                    ),
                  ],
                  if (latestJournal == null && latestGratitude == null)
                    Center(
                      child: Text("No reflections released yet.", style: GoogleFonts.outfit(color: Colors.grey[400], fontSize: 14)),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActivityTile(IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(icon, color: const Color(0xFF065643), size: 20),
        title: Text(
          title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500, color: const Color(0xFF065643), fontSize: 15),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey[400]),
      ),
    );
  }
}
