import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';

class CaretakerCompanionScreen extends StatefulWidget {
  const CaretakerCompanionScreen({super.key});

  @override
  State<CaretakerCompanionScreen> createState() => _CaretakerCompanionScreenState();
}

class _CaretakerCompanionScreenState extends State<CaretakerCompanionScreen> {
  int _waterGlasses = 0;
  final List<String> _loggedMeals = [];
  bool _screenOff = false;
  bool _stretching = false;
  bool _sleepMixerReady = false;
  
  final TextEditingController _thoughtController = TextEditingController();
  String _caretakerResponse = "";
  bool _isResponding = false;

  // Curated time-based styles and settings
  late int _currentHour;
  late String _greeting;
  late Color _primaryColor;
  late Color _cardColor;
  late String _caretakerEmoji;

  @override
  void initState() {
    super.initState();
    _currentHour = DateTime.now().hour;
    _initializeCaretakerSettings();
  }

  void _initializeCaretakerSettings() {
    _cardColor = Colors.white;
    
    // 5 AM to 11:59 AM - Morning
    if (_currentHour >= 5 && _currentHour < 12) {
      _greeting = "Good morning, dear soul. Did you sleep peacefully? Let's hydrate together and set a gentle intention for the hours ahead.";
      _primaryColor = const Color(0xFF0A7D62);
      _caretakerEmoji = "🌸";
    }
    // 12 PM to 4:59 PM - Afternoon
    else if (_currentHour >= 12 && _currentHour < 17) {
      _greeting = "Hello there. Have you paused to enjoy a nourishing lunch or rest your eyes? Let's take a slow breath and step back from the rush.";
      _primaryColor = const Color(0xFF065643);
      _caretakerEmoji = "🍃";
    }
    // 5 PM to 8:59 PM - Evening / Sunset
    else if (_currentHour >= 17 && _currentHour < 21) {
      _greeting = "The day is winding down beautifully. How did you feel today? Share one little thing you did well, and let's release the rest.";
      _primaryColor = const Color(0xFF0A7D62);
      _caretakerEmoji = "🌅";
    }
    // 9 PM to 4:59 AM - Night
    else {
      _greeting = "Good evening. It is time to gently rest your thoughts. The world can wait. Shall we log our tranquil wind-down routine?";
      _primaryColor = const Color(0xFF065643);
      _caretakerEmoji = "🌙";
    }

    _caretakerResponse = "I'm right here with you. Take your time, and tell me whatever is on your heart.";
  }

  void _handleTalkToCaretaker() {
    final thought = _thoughtController.text.trim();
    if (thought.isEmpty) return;

    setState(() {
      _isResponding = true;
    });

    // Simulate comforting response with custom clinic-friendly triggers
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isResponding = false;
        String t = thought.toLowerCase();
        if (t.contains("sad") || t.contains("depressed") || t.contains("cry")) {
          _caretakerResponse = "I hear you, and it is completely okay to feel sad. Please remember that you don't have to carry this heavy feeling all alone. I'm right here holding space for you, and we can take it one tiny step at a time.";
        } else if (t.contains("anxious") || t.contains("stressed") || t.contains("scared") || t.contains("worry")) {
          _caretakerResponse = "Your nervous system is just trying to protect you, but you are safe right now. Let's take a slow, deep breath in... and let it out. I'm keeping watch; you are completely okay to just be.";
        } else if (t.contains("tired") || t.contains("exhausted")) {
          _caretakerResponse = "You've worked so hard. It is completely okay to let go of your productivity now. Close your eyes, hydrate a bit, and rest. You are worthy of peace, independent of how much you got done.";
        } else if (t.contains("happy") || t.contains("good") || t.contains("excited")) {
          _caretakerResponse = "A beautiful spark! I'm smiling with you. Thank you for sharing this bright moment with me. Let's tuck this feeling in our hearts to remember during darker hours.";
        } else {
          _caretakerResponse = "Thank you for trusting me with your raw thoughts. I am holding space for you. Remember to speak kindly to yourself today—you are doing much better than you realize.";
        }
        _thoughtController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textThemeColor = const Color(0xFF065643);
    Color subTextColor = Colors.grey[700]!;

    return Scaffold(
      body: ZenBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Dynamic Header Bar
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: textThemeColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Caretaker Companion",
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textThemeColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: textThemeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _caretakerEmoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Caretaker Character & Active Bubble
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: _primaryColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _caretakerEmoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Aakaa Caretaker",
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: textThemeColor,
                                    ),
                                  ),
                                  Text(
                                    "Active & Listening",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      color: _primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Divider(color: textThemeColor.withValues(alpha: 0.08)),
                        const SizedBox(height: 12),
                        Text(
                          _greeting,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            height: 1.5,
                            color: textThemeColor.withValues(alpha: 0.9),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Interactive logs sections
              SliverPadding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Self-Care Counters",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textThemeColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Hydration Logger
                      _buildLogSection(
                        title: "Hydration Intake",
                        subtitle: "Track your body's vital fluids",
                        icon: Icons.local_drink_rounded,
                        isDark: isDark,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$_waterGlasses Glass${_waterGlasses == 1 ? '' : 'es'}",
                                  style: GoogleFonts.outfit(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: textThemeColor,
                                  ),
                                ),
                                Text(
                                  "Target: 8 Glasses",
                                  style: GoogleFonts.outfit(fontSize: 12, color: subTextColor),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _buildCircleButton(
                                  icon: Icons.remove_rounded,
                                  onPressed: () {
                                    if (_waterGlasses > 0) {
                                      setState(() => _waterGlasses--);
                                    }
                                  },
                                  color: textThemeColor,
                                ),
                                const SizedBox(width: 12),
                                _buildCircleButton(
                                  icon: Icons.add_rounded,
                                  onPressed: () {
                                    setState(() => _waterGlasses++);
                                  },
                                  color: textThemeColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Meal Tracker
                      _buildLogSection(
                        title: "Meal Logging",
                        subtitle: "Nourish your body at the right intervals",
                        icon: Icons.restaurant_rounded,
                        isDark: isDark,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ["Breakfast", "Lunch", "Dinner", "Snacks"].map((meal) {
                            bool isLogged = _loggedMeals.contains(meal);
                            return FilterChip(
                              label: Text(
                                meal,
                                style: GoogleFonts.outfit(
                                  color: isLogged ? Colors.white : textThemeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              selected: isLogged,
                              selectedColor: _primaryColor,
                              checkmarkColor: Colors.white,
                              backgroundColor: textThemeColor.withValues(alpha: 0.05),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              side: BorderSide(color: textThemeColor.withValues(alpha: 0.1)),
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    _loggedMeals.add(meal);
                                  } else {
                                    _loggedMeals.remove(meal);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Cozy Wind-Down Routine
                      _buildLogSection(
                        title: "Wind-Down Checklist",
                        subtitle: "Prepare your nervous system for peace",
                        icon: Icons.bedtime_rounded,
                        isDark: isDark,
                        child: Column(
                          children: [
                            _buildCheckRow("Screen-free winddown (30 mins)", _screenOff, (v) => setState(() => _screenOff = v!)),
                            _buildCheckRow("Gentle muscle stretching", _stretching, (v) => setState(() => _stretching = v!)),
                            _buildCheckRow("Zen Sleep ambient mixer ready", _sleepMixerReady, (v) => setState(() => _sleepMixerReady = v!)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Cozy interactive chat
                      _buildLogSection(
                        title: "Whisper Your Feelings",
                        subtitle: "A completely private, secure room to write",
                        icon: Icons.chat_bubble_rounded,
                        isDark: isDark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: textThemeColor.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: _isResponding
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          "Caretaker is crafting warm words...",
                                          style: GoogleFonts.outfit(fontStyle: FontStyle.italic, fontSize: 13, color: subTextColor),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      _caretakerResponse,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        height: 1.4,
                                        color: textThemeColor.withValues(alpha: 0.8),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _thoughtController,
                                    style: GoogleFonts.outfit(color: textThemeColor),
                                    decoration: InputDecoration(
                                      hintText: "How are you inside?",
                                      hintStyle: GoogleFonts.outfit(color: subTextColor.withValues(alpha: 0.5)),
                                      filled: true,
                                      fillColor: textThemeColor.withValues(alpha: 0.05),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    ),
                                    onSubmitted: (_) => _handleTalkToCaretaker(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: _handleTalkToCaretaker,
                                  child: Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      color: _primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
    required bool isDark,
  }) {
    Color textThemeColor = isDark ? Colors.white : const Color(0xFF065643);
    Color subTextColor = isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey[600]!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _primaryColor, size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textThemeColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(fontSize: 12, color: subTextColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildCheckRow(String text, bool value, ValueChanged<bool?> onChanged) {
    Color textThemeColor = const Color(0xFF065643);

    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        text,
        style: GoogleFonts.outfit(fontSize: 14, color: textThemeColor, fontWeight: FontWeight.w500),
      ),
      activeColor: _primaryColor,
      checkColor: Colors.white,
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
