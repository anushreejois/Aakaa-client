import 'package:flutter/material.dart';

class PageSlide {
  final  pageController = PageController();
  int currentPage = 0;

  final List<String> infoTexts = [ 
    "Aakaa: Your Inner Sky\nDiscover a sanctuary for healing, growth, and mindful living.",
    "Personalized Therapy\nConnect with professional psychologists tailored to your unique journey.",
    "Breathe. Heal. Grow.\nEmpowering your mind with evidence-based practices and care.",
  ];

  final List<IconData> infoIcons = [
    Icons.auto_awesome_rounded,
    Icons.psychology_rounded,
    Icons.favorite_rounded,
  ];

  /// Called when user swipes or changes page manually
  void onPageChanged(int index, VoidCallback refreshUI) {
    currentPage = index;
    refreshUI(); // triggers setState() from UI
  }

   /// Called when Continue button is pressed
  void nextPage(VoidCallback refreshUI) {
    if (currentPage < infoTexts.length - 1) {
      currentPage++;
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
    refreshUI();
  }

  bool get isLastPage => currentPage == infoTexts.length - 1;

  void dispose() {
    pageController.dispose();
  }
}
