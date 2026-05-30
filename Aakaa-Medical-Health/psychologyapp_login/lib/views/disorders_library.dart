import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';
import 'package:psychologyapp_login/views/disorder_detail_screen.dart';

class DisordersLibrary extends StatefulWidget {
  const DisordersLibrary({super.key});

  @override
  State<DisordersLibrary> createState() => _DisordersLibraryState();
}

class _DisordersLibraryState extends State<DisordersLibrary> {
  final List<Map<String, dynamic>> _disorders = [
    {
      "title": "Anxiety Disorders",
      "icon": Icons.psychology_rounded,
      "description": "Understanding generalized anxiety, panic, and phobias.",
      "longDescription": "Anxiety disorders are characterized by persistent, excessive worry that interferes with daily activities. They are more than temporary stress, often manifesting physically as tension, heart palpitations, and sleep disturbances.",
      "prevalence": "Affects approximately 301 million people globally.",
      "symptoms": [
        "Persistent feelings of tension or apprehension",
        "Irritability and difficulty concentrating",
        "Physical indicators like rapid breathing, sweating, or trembling",
        "Avoidance of situations that trigger distress"
      ],
      "copingStrategies": [
        "Box Breathing: Inhale for 4 seconds, hold for 4, exhale for 4, hold for 4.",
        "5-4-3-2-1 Grounding: Acknowledge 5 things you see, 4 you feel, 3 you hear, 2 you smell, and 1 you taste.",
        "Thought Logging: Challenge anxious scripts by examining objective evidence."
      ]
    },
    {
      "title": "Mood Disorders",
      "icon": Icons.wb_sunny_rounded,
      "description": "Exploring depression and bipolar spectrum conditions.",
      "longDescription": "Mood disorders involve severe fluctuations in emotional states that impact everyday functioning. The most common spectrums include Major Depressive Disorder (insistent low mood or loss of interest) and Bipolar Disorder (swings between mania and depression).",
      "prevalence": "Affects over 280 million people worldwide.",
      "symptoms": [
        "Persistent feelings of sadness, emptiness, or hopelessness",
        "Loss of interest or pleasure in once-enjoyable activities",
        "Drastic changes in appetite, weight, or sleeping habits",
        "Feelings of worthlessness or excessive, misplaced guilt"
      ],
      "copingStrategies": [
        "Behavioral Activation: Gently schedule small, low-pressure tasks daily.",
        "Gratitude Reflecting: Write down three genuine micro-positives every morning.",
        "Somatic Grounding: Focus strictly on physical sensations to draw awareness out of depressive loops."
      ]
    },
    {
      "title": "Sleep Disorders",
      "icon": Icons.bedtime_rounded,
      "description": "Insights into insomnia and sleep cycle regulation.",
      "longDescription": "Sleep disorders disrupt the quantity, quality, and timing of sleep, which severely impacts mental and physiological resilience. Conditions like insomnia can be both a symptom and a cause of mood and anxiety imbalances.",
      "prevalence": "Affects nearly 30% of adults globally at some stage.",
      "symptoms": [
        "Difficulty falling asleep or waking up frequently during the night",
        "Waking up too early and being unable to fall back asleep",
        "Feeling unrefreshed, fatigued, or irritable during daylight hours",
        "Tension or anxiety surrounding bedtime routines"
      ],
      "copingStrategies": [
        "Bedtime Cognitive Shuffling: Think of random words to distract the brain.",
        "Sleep Hygiene Protocols: Maintain absolute darkness, block blue screens 1 hour before sleep.",
        "Progressive Muscle Relaxation (PMR): Tense and release muscle groups from toe to head."
      ]
    },
    {
      "title": "Stress & Trauma",
      "icon": Icons.spa_rounded,
      "description": "Navigating PTSD and chronic stress management.",
      "longDescription": "Trauma and stressor-related disorders, such as PTSD, emerge following exposure to highly distressing, life-altering events. Chronic stress triggers long-term cortisol production, keeping the nervous system locked in fight-or-flight.",
      "prevalence": "Estimated 3.9% of the global population suffers from PTSD.",
      "symptoms": [
        "Intrusive memories, distressing dreams, or vivid flashbacks of events",
        "Avoidance of thoughts, feelings, or places connected to stressors",
        "Hyper-vigilance, exaggerated startle response, or insomnia",
        "Negative alterations in cognition, mood, or emotional warmth"
      ],
      "copingStrategies": [
        "Bilaterial Tapping: Alternate tapping shoulders to ground the hemispheres.",
        "The Container Exercise: Mentally lock stressful triggers in a secure box to process later.",
        "Therapeutic Writing: Express emotional trauma triggers slowly in a safe, non-judgmental journal."
      ]
    },
    {
      "title": "Obsessive-Compulsive (OCD)",
      "icon": Icons.loop_rounded,
      "description": "Understanding intrusive thoughts and compulsive behaviors.",
      "longDescription": "Obsessive-Compulsive Disorder (OCD) is a chronic condition where a person has uncontrollable, recurring thoughts (obsessions) and/or behaviors (compulsions) that they feel the urge to repeat in response to the obsession.",
      "prevalence": "Affects approximately 1.5% to 2% of the global population.",
      "symptoms": [
        "Intrusive, unwanted thoughts or mental images that cause anxiety",
        "Urges to perform repetitive rituals (checking, washing, counting)",
        "Fear of contamination, asymmetry, or harm happening to self/others",
        "Temporary relief only achieved by completing the compulsive ritual"
      ],
      "copingStrategies": [
        "Exposure and Response Prevention (ERP): Expose yourself to a trigger, then slowly delay performing the ritual.",
        "Thought Labeling: Mentally label intrusive thoughts: 'This is just an OCD wave, not a fact.'",
        "The 15-Minute Rule: Delay acting on a compulsion by 15 minutes, breathing slowly to let the anxiety peak and decline."
      ]
    },
    {
      "title": "ADHD Spectrum",
      "icon": Icons.track_changes_rounded,
      "description": "Insights into executive dysfunction, inattention, and focus.",
      "longDescription": "Attention-Deficit/Hyperactivity Disorder (ADHD) is a neurodevelopmental condition characterized by persistent patterns of inattention, hyperactivity, and impulsivity that impact executive functioning and daily organization.",
      "prevalence": "Affects roughly 5% of children and 2.5% of adults worldwide.",
      "symptoms": [
        "Difficulty sustaining attention or focus on long, non-stimulating tasks",
        "Frequent executive dysfunction, forgetfulness, or losing daily items",
        "Restlessness, physical fidgeting, or talking excessively",
        "Impulsivity or difficulty waiting for turns in conversation"
      ],
      "copingStrategies": [
        "Body Doubling: Work on tasks alongside someone else to stay grounded.",
        "The Pomodoro Technique: Work for 25 minutes, then take a mandatory 5-minute movement break.",
        "Dopamine Menu (Dopa-menu): Keep a visual list of healthy, quick dopamine-boosting actions to reset focus."
      ]
    },
    {
      "title": "Eating Disorders",
      "icon": Icons.healing_rounded,
      "description": "Navigating body image, anorexia, and emotional eating.",
      "longDescription": "Eating disorders are serious, complex mental health conditions characterized by severely disrupted eating behaviors, obsessive thoughts surrounding weight, and distorted body image perceptions that impact clinical health.",
      "prevalence": "Affects roughly 9% of the population globally.",
      "symptoms": [
        "Severe restriction of food intake or extreme fear of weight gain",
        "Binge eating episodes followed by compensatory behaviors",
        "Obsessive checking of mirrors, body parts, or nutritional labels",
        "Withdrawing from social events or meals involving food"
      ],
      "copingStrategies": [
        "Urge Surfing: Visualize the urge to restrict or binge as an ocean wave; breathe slowly and ride it until it breaks.",
        "Opposite Action: Act against the unhelpful emotional impulse (e.g., eat a scheduled meal even if anxious).",
        "Cognitive Re-framing: Challenge distorted body scripts by focusing on your body's functional strengths."
      ]
    },
    {
      "title": "Personality Disorders",
      "icon": Icons.bubble_chart_rounded,
      "description": "Understanding BPD, emotional instability, and relational patterns.",
      "longDescription": "Personality disorders involve enduring, inflexible patterns of thinking, feeling, and behaving that deviate significantly from cultural expectations and cause ongoing distress or functional impairment, particularly in interpersonal relationships.",
      "prevalence": "Affects approximately 7.8% of the global population.",
      "symptoms": [
        "Intense fears of abandonment and unstable relationship patterns",
        "Rapidly shifting self-image, goals, and core values",
        "Extreme mood swings, chronic emptiness, or intense anger",
        "Impulsive, self-damaging behaviors or emotional dysregulation"
      ],
      "copingStrategies": [
        "STOP Skill: Stop, Take a step back, Observe your feelings, and Proceed mindfully.",
        "TIPP Skills: Temperature shift (cold water), Intense exercise, Paced breathing, Paired muscle relaxation.",
        "Radical Acceptance: Accept reality completely as it is in this moment, without judgment."
      ]
    },
    {
      "title": "Substance Use & Addiction",
      "icon": Icons.health_and_safety_rounded,
      "description": "Navigating dependency, behavior loops, and recovery paths.",
      "longDescription": "Substance use and addictive disorders are complex conditions characterized by compulsive drug or alcohol consumption, or behavioral loops, despite harmful consequences, altering brain pathways related to reward and self-control.",
      "prevalence": "Affects over 270 million people worldwide.",
      "symptoms": [
        "Compulsive cravings or inability to limit substance intake/behavior",
        "Tolerance requiring larger amounts to achieve the same effect",
        "Withdrawal symptoms when attempting to reduce or stop use",
        "Neglecting social, professional, or recreational duties"
      ],
      "copingStrategies": [
        "Delay & Distract: Wait 15 minutes during a craving, engaging in a high-engagement secondary activity.",
        "Trigger Mapping: Write down people, places, and emotions that trigger cravings to build buffer zones.",
        "HALT Check: Ask if you are Hungry, Angry, Lonely, or Tired when cravings emerge, and resolve that physical need first."
      ]
    },
  ];

  List<Map<String, dynamic>> _filteredDisorders = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredDisorders = _disorders;
    _searchController.addListener(_filterDisorders);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDisorders() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredDisorders = _disorders;
      } else {
        _filteredDisorders = _disorders.where((d) {
          final title = d['title'].toString().toLowerCase();
          final desc = d['description'].toString().toLowerCase();
          final longDesc = (d['longDescription'] ?? '').toString().toLowerCase();
          return title.contains(query) || desc.contains(query) || longDesc.contains(query);
        }).toList();
      }
    });
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
                  "Disorders Hub",
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
                  children: [
                    const SizedBox(height: 10),
                    _buildSearchBar(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildDisorderCard(_filteredDisorders[index]),
                  childCount: _filteredDisorders.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.w600),
        cursorColor: const Color(0xFF065643),
        decoration: InputDecoration(
          hintText: "Search library...",
          hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.4), fontSize: 15),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF065643), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildDisorderCard(Map<String, dynamic> disorder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF065643).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(disorder['icon'], color: const Color(0xFF065643), size: 24),
        ),
        title: Text(
          disorder['title'],
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF065643),
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          disorder['description'],
          style: GoogleFonts.outfit(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) => DisorderDetailScreen(disorder: disorder),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
      ),
    );
  }
}
