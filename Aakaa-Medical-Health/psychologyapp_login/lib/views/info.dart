import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/controllers/pageslide.dart';
import 'package:psychologyapp_login/views/clientlogin.dart';
import '../widgets/zen_background.dart';

class Info extends StatefulWidget {
  final bool isFromSettings;
  const Info({super.key, this.isFromSettings = false});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> with SingleTickerProviderStateMixin {
  final PageSlide pageSlide = PageSlide();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    pageSlide.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      if (pageSlide.isLastPage) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientLogin()),
                    ),
                    child: Text(
                      "Skip",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF065643),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: pageSlide.pageController,
                  onPageChanged: (index) {
                    pageSlide.currentPage = index;
                    _updateButtonState();
                  },
                  itemCount: pageSlide.infoTexts.length,
                  itemBuilder: (context, index) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.2, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        key: ValueKey(index),
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Center(
                          child: Text(
                            pageSlide.infoTexts[index],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF065643),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pageSlide.infoTexts.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: const EdgeInsets.symmetric(horizontal: 6.0),
                    width: pageSlide.currentPage == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: pageSlide.currentPage == index
                          ? const Color(0xFF065643)
                          : const Color(0xFF065643).withValues(alpha: 0.15),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!pageSlide.isLastPage)
                        SizedBox(
                          width: double.infinity,
                          height: 65,
                          child: ElevatedButton(
                            onPressed: () {
                              pageSlide.nextPage(() {
                                setState(() {});
                                _updateButtonState();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF065643),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                            ),
                            child: Text(
                              "Continue",
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFFFF7F5),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (pageSlide.isLastPage)
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 65,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF065643).withValues(alpha: 0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (widget.isFromSettings) {
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (_) => const ClientLogin()),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Text(
                                        widget.isFromSettings ? "Finish" : "Get Started",
                                        style: GoogleFonts.outfit(
                                          color: const Color(0xFFFFF7F5),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
