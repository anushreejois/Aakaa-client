import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'disorder_guide.dart';

class DisordersLibrary extends StatefulWidget {
  const DisordersLibrary({super.key});

  @override
  State<DisordersLibrary> createState() => _DisordersLibraryState();
}

class _DisordersLibraryState extends State<DisordersLibrary> {
  final List<Map<String, dynamic>> _disorders = [
    {
      "title": "Anxiety Disorders",
      "subtitle": "Persistent worry and fear",
      "description": "Anxiety disorders involve more than temporary worry or fear. For people with an anxiety disorder, the anxiety does not go away and can get worse over time.",
      "icon": Icons.psychology_alt_rounded,
    },
    {
      "title": "Depression",
      "subtitle": "Persistent low mood",
      "description": "Depression (major depressive disorder) is a common and serious medical illness that negatively affects how you feel, the way you think and how you act.",
      "icon": Icons.water_drop_rounded,
    },
    {
      "title": "ADHD",
      "subtitle": "Attention & Hyperactivity",
      "description": "ADHD is a developmental disorder where people show a persistent pattern of inattention and/or hyperactivity-impulsivity that interferes with functioning.",
      "icon": Icons.bolt_rounded,
    },
    {
      "title": "PTSD",
      "subtitle": "Post-Traumatic Stress",
      "description": "PTSD is a disorder that develops in some people who have experienced a shocking, scary, or dangerous event.",
      "icon": Icons.security_rounded,
    },
    {
      "title": "OCD",
      "subtitle": "Obsessive-Compulsive",
      "description": "OCD is a common, chronic, and long-lasting disorder in which a person has uncontrollable, reoccurring thoughts and behaviors.",
      "icon": Icons.sync_rounded,
    },
    {
      "title": "Sleep Disorders",
      "subtitle": "Insomnia & Quality of Sleep",
      "description": "Sleep disorders are conditions that result in changes in the way that you sleep. A sleep disorder can affect your overall health, safety and quality of life.",
      "icon": Icons.bedtime_rounded,
    },
    {
      "title": "Eating Disorders",
      "subtitle": "Unhealthy relationship with food",
      "description": "Eating disorders are serious illnesses related to eating behaviors that negatively impact your health, your emotions, and your ability to function.",
      "icon": Icons.restaurant_menu_rounded,
    },
    {
      "title": "Bipolar Disorder",
      "subtitle": "Extreme mood swings",
      "description": "Bipolar disorder causes extreme mood swings that include emotional highs (mania or hypomania) and lows (depression).",
      "icon": Icons.balance_rounded,
    },
    {
      "title": "Social Anxiety",
      "subtitle": "Fear of social situations",
      "description": "Social anxiety disorder is an intense, persistent fear of being watched and judged by others. This fear can affect work, school, and other daily activities.",
      "icon": Icons.groups_rounded,
    },
    {
      "title": "Schizophrenia",
      "subtitle": "Complex thought disorder",
      "description": "Schizophrenia is a serious mental disorder in which people interpret reality abnormally. It may result in some combination of hallucinations and delusions.",
      "icon": Icons.blur_on_rounded,
    },
  ];

  String _searchQuery = "";
  int _hintIndex = 0;
  late List<String> _searchHints;
  Timer? _hintTimer;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchHints = [
      "Search Anxiety...",
      "Search Depression...",
      "Search ADHD...",
      "Search PTSD...",
      "Search Sleep Disorders...",
      "Search Bipolar...",
    ];
    _hintTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _hintIndex = (_hintIndex + 1) % _searchHints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDisorders = _disorders
        .where((d) => d['title']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (Matching Daily Affirmations)
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
            bottom: 200,
            left: -80,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.white.withOpacity(0.03),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // iOS Style AppBar
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
                    "Disorders Hub",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2), // Darker background for contrast
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Stack(
                      children: [
                        // Animated Hint Text
                        if (_searchQuery.isEmpty)
                          Positioned(
                            left: 48,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.2),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Text(
                                  _searchHints[_hintIndex],
                                  key: ValueKey<String>(_searchHints[_hintIndex]),
                                  style: GoogleFonts.outfit(
                                    color: Colors.white.withOpacity(0.9), // High visibility
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => _searchQuery = value),
                          style: GoogleFonts.outfit(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search_rounded, color: Colors.white, size: 22),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // List of Disorders
              SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final disorder = filteredDisorders[index];
                      return _buildDisorderCard(disorder);
                    },
                    childCount: filteredDisorders.length,
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisorderCard(Map<String, dynamic> disorder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              disorder["icon"] as IconData,
              color: Colors.white,
              size: 26,
            ),
          ),
          title: Text(
            disorder["title"]!,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          subtitle: Text(
            disorder["subtitle"]!,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54, size: 24),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disorder["description"]!,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisorderGuide(disorder: disorder),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Open Resource Guide",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF065643),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF065643)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
