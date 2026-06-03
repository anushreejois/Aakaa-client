import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';
import 'package:psychologyapp_login/views/findtherapist.dart';

class DisorderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> disorder;

  const DisorderDetailScreen({super.key, required this.disorder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF065643).withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.15), width: 2),
                        ),
                        child: Icon(disorder['icon'], color: const Color(0xFF065643), size: 50),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7F5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        disorder['title'],
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // 🌟 Clinical Overview Section
                      Text(
                        "Clinical Overview",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        disorder['longDescription'] ?? disorder['description'],
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🌟 Dynamic Prevalence Badge Card
                      if (disorder['prevalence'] != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7F5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.analytics_outlined, color: Color(0xFF065643), size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  disorder['prevalence'],
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF065643),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // 🌟 Common Symptoms Check-List
                      if (disorder['symptoms'] != null) ...[
                        Text(
                          "Key Diagnostic Symptoms",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF065643),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate((disorder['symptoms'] as List).length, (idx) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF0A7D62), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    disorder['symptoms'][idx],
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 32),
                      ],

                      // 🌟 Actionable Coping Strategies Cards
                      if (disorder['copingStrategies'] != null) ...[
                        Text(
                          "Actionable Coping Strategies",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF065643),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate((disorder['copingStrategies'] as List).length, (idx) {
                          final text = disorder['copingStrategies'][idx] as String;
                          final parts = text.split(':');
                          final label = parts[0];
                          final desc = parts.length > 1 ? parts[1] : '';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.01),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.self_improvement_rounded, color: Color(0xFF065643), size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      label,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF065643),
                                      ),
                                    ),
                                  ],
                                ),
                                if (desc.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    desc.trim(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 32),
                      ],

                      // 🌟 Clinical Assessment Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF065643).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF065643), size: 24),
                                const SizedBox(width: 12),
                                Text(
                                  "Clinical Self-Assessment",
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF065643),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Take a short, interactive clinical-grade self-screening quiz to evaluate your symptom level and get personalized care guidance.",
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => ClinicalScreeningQuiz(
                                      disorderTitle: disorder['title'],
                                      matchTag: _getMatchTag(disorder['title']),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF065643),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Start Screening Quiz",
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Professional Disclaimer Box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF065643).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded, color: Color(0xFF065643), size: 24),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "Professional help is the most effective way to manage and overcome these symptoms. Our certified therapists are here to guide you.",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF065643),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 300),
                                pageBuilder: (context, animation, secondaryAnimation) => FindTherapist(
                                  selectedTag: _getMatchTag(disorder['title']),
                                ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(opacity: animation, child: child);
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF065643),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 0,
                          ),
                          child: Text(
                            "Find a Therapist",
                            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMatchTag(String title) {
    if (title.contains("Anxiety")) return "Anxiety";
    if (title.contains("Mood")) return "Depression";
    if (title.contains("Sleep")) return "Insomnia";
    if (title.contains("Stress") || title.contains("Trauma")) return "Stress";
    if (title.contains("OCD")) return "CBT";
    if (title.contains("ADHD")) return "Mindfulness";
    if (title.contains("Eating")) return "Anxiety";
    if (title.contains("Personality")) return "Depression";
    return "Stress";
  }
}

class ClinicalScreeningQuiz extends StatefulWidget {
  final String disorderTitle;
  final String matchTag;

  const ClinicalScreeningQuiz({
    super.key,
    required this.disorderTitle,
    required this.matchTag,
  });

  @override
  State<ClinicalScreeningQuiz> createState() => _ClinicalScreeningQuizState();
}

class _ClinicalScreeningQuizState extends State<ClinicalScreeningQuiz> {
  int _currentQuestionIndex = 0;
  int _totalScore = 0;
  bool _quizCompleted = false;

  final List<String> _answers = [
    "Not at all",
    "Several days",
    "More than half the days",
    "Nearly every day"
  ];

  List<String> _getQuestions() {
    final title = widget.disorderTitle;
    if (title.contains("Anxiety")) {
      return [
        "Feeling nervous, anxious, or on edge?",
        "Not being able to stop or control worrying?",
        "Worrying too much about different things?",
        "Trouble relaxing or feeling restless?",
        "Becoming easily annoyed or irritable due to anxiety?",
        "Feeling afraid, as if something awful might happen?",
        "Experiencing physical symptoms like a racing heart, sweating, or shaking when worried?"
      ];
    } else if (title.contains("Mood")) {
      return [
        "Little interest or pleasure in doing things?",
        "Feeling down, depressed, or hopeless?",
        "Trouble falling/staying asleep, or sleeping too much?",
        "Feeling tired, fatigued, or having low energy?",
        "Poor appetite or overeating?",
        "Feeling bad about yourself — or that you are a failure or have let yourself or your family down?",
        "Trouble concentrating on things, such as reading the newspaper or watching television?"
      ];
    } else if (title.contains("Sleep")) {
      return [
        "Difficulty falling asleep, staying asleep, or waking too early?",
        "How satisfied/dissatisfied are you with your current sleep pattern?",
        "How much does your sleep pattern interfere with daily functioning?",
        "How worried or distressed are you about your current sleep difficulties?",
        "Waking up in the middle of the night and struggling to quiet your mind?",
        "Experiencing daytime sleepiness, lack of energy, or difficulty concentrating?",
        "Feeling anxious or tense when thinking about or preparing for bed?"
      ];
    } else if (title.contains("Stress") || title.contains("Trauma")) {
      return [
        "Experiencing intrusive, distressing memories or flashbacks?",
        "Avoiding thoughts, feelings, or situations related to trauma?",
        "Feeling hypervigilant, irritable, or easily startled?",
        "Difficulty sleeping or concentrating due to emotional stress?",
        "Feeling emotionally numb or detached from loved ones and activities?",
        "Having strong physical reactions (like sweating or heart racing) when reminded of a stressful event?",
        "Feeling constantly on guard or alert, even in safe environments?"
      ];
    } else if (title.contains("OCD")) {
      return [
        "Having intrusive, unwanted thoughts that cause severe anxiety?",
        "Feeling driven to perform repetitive behaviors (checking, washing, ordering)?",
        "Experiencing extreme distress if rituals are interrupted?",
        "Rituals taking up significant time or impacting daily activities?",
        "Feeling an overwhelming need for symmetry, order, or absolute perfection?",
        "Repeatedly doubting or checking things (e.g., locks, appliances) to prevent harm?",
        "Struggling to control or stop repetitive mental acts (like counting or praying silently) to ease anxiety?"
      ];
    } else if (title.contains("ADHD")) {
      return [
        "Trouble organizing tasks, forgetfulness, or losing daily items?",
        "Difficulty sustaining attention or focusing on long activities?",
        "Restlessness, constant physical fidgeting, or talking excessively?",
        "Acting on impulse or speaking without waiting for your turn?",
        "Struggling to initiate tasks or easily getting sidetracked by unrelated distractions?",
        "Difficulty keeping track of time or meeting deadlines (time blindness)?",
        "Feeling internally restless or mentally exhausted from trying to focus?"
      ];
    } else if (title.contains("Eating")) {
      return [
        "Severe anxiety about body shape, weight, or food intake?",
        "Urges to restrict meals or binge eat compulsively?",
        "Compensatory behaviors or guilt surrounding eating?",
        "Obsessively monitoring mirrors, scale numbers, or nutritional labels?",
        "Feeling that your self-worth is entirely determined by your body shape or weight?",
        "Eating in secret or feeling out of control when eating?",
        "Avoiding social gatherings or activities because they involve food?"
      ];
    } else if (title.contains("Personality")) {
      return [
        "Intense fear of abandonment or highly unstable relationships?",
        "Rapid shifts in self-image, goals, or core values?",
        "Frequent extreme mood swings or feelings of chronic emptiness?",
        "Intense, inappropriate anger or difficulty controlling emotions?",
        "Engaging in impulsive, risky behaviors under high emotional distress?",
        "Feeling paranoid or experiencing temporary disconnects from reality when stressed?",
        "Struggling to maintain a stable sense of who you are or what you want?"
      ];
    } else {
      return [
        "Compulsive cravings or inability to limit substance/behavior loops?",
        "Tolerance requiring larger amounts to feel satisfied?",
        "Experiencing distress or withdrawal when trying to cut back?",
        "Neglecting work, social, or recreational priorities for the habit?",
        "Using substances or behaviors to escape, numb, or cope with difficult emotions?",
        "Continuing the habit even when knowing it is causing physical or psychological harm?",
        "Failing in attempts to cut down or control the frequency of the behavior?"
      ];
    }
  }

  Map<String, dynamic> _getFeedback() {
    if (_totalScore <= 7) {
      return {
        "status": "Mild / Supportive Focus",
        "color": const Color(0xFF0A7D62),
        "desc": "Your symptoms indicate a mild level of distress. We highly recommend practicing daily breathing, logging your reflective journal, and exploring our sleep ambient sound sanctuaries to maintain your emotional alignment."
      };
    } else if (_totalScore <= 14) {
      return {
        "status": "Moderate / Active Action",
        "color": Colors.orange[800],
        "desc": "You are experiencing moderate levels of stress or anxiety. Guided mindfulness tools, daily therapeutic exercises, and connecting with a clinical coach are exceptionally effective paths forward."
      };
    } else {
      return {
        "status": "Severe / High Attention",
        "color": Colors.red[800],
        "desc": "Your self-screening marks a higher clinical index. Please remember that healing is completely possible, and reaching out to a professional therapist specialized in your specific area is the safest and most therapeutic next step."
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = _getQuestions();
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF7F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          // Background soft accent
          Positioned(
            right: -50,
            top: -50,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: const Color(0xFF065643).withValues(alpha: 0.03),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _quizCompleted ? "Screening Complete" : "Self-Assessment Quiz",
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF065643)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                if (!_quizCompleted) ...[
                  // Progress Indicator
                  LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / questions.length,
                    backgroundColor: const Color(0xFF065643).withValues(alpha: 0.08),
                    color: const Color(0xFF065643),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Question ${_currentQuestionIndex + 1} of ${questions.length}",
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF065643).withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 36),
                  
                  // Question Box
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questions[_currentQuestionIndex],
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF065643),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Choices
                        Expanded(
                          child: ListView.builder(
                            itemCount: _answers.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, idx) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF065643).withValues(alpha: 0.08),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.01),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    onTap: () {
                                      setState(() {
                                        _totalScore += idx;
                                        if (_currentQuestionIndex < questions.length - 1) {
                                          _currentQuestionIndex++;
                                        } else {
                                          _quizCompleted = true;
                                        }
                                      });
                                    },
                                    leading: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: const Color(0xFF065643).withValues(alpha: 0.05),
                                      child: Text(
                                        "${idx + 1}",
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF065643),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      _answers[idx],
                                      style: GoogleFonts.outfit(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF065643),
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: const Color(0xFF065643).withValues(alpha: 0.3),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Results Box
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          
                          // Score Circle
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF065643).withValues(alpha: 0.1),
                                width: 8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                )
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "$_totalScore",
                                    style: GoogleFonts.outfit(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF065643),
                                    ),
                                  ),
                                  Text(
                                    "out of 12",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 28),
                          
                          // Symptom Level Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: _getFeedback()['color'].withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: _getFeedback()['color'].withValues(alpha: 0.15),
                              ),
                            ),
                            child: Text(
                              _getFeedback()['status'],
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _getFeedback()['color'],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Empathetic Clinical Description
                          Text(
                            _getFeedback()['desc'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              color: Colors.grey[700],
                              height: 1.6,
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Payout action matched button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // close bottom sheet
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(milliseconds: 300),
                                    pageBuilder: (context, animation, secondaryAnimation) => FindTherapist(
                                      selectedTag: widget.matchTag,
                                    ),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF065643),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                "Direct Match with Specialist",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Back to Disorders Hub",
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF065643),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
