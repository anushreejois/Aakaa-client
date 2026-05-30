import 'package:flutter/material.dart';

class PageSlide {
  final  pageController = PageController();
  int currentPage = 0;

  final List<String> infoTexts = [ 
    "Aakaa: The Space Within\nStep into a quiet, cloudless sanctuary designed to soothe your thoughts, embrace your emotions, and align your inner sky.",
    "Grounded Guidance\nFind absolute solace with hand-picked, certified specialists walking gently beside you through every shift of wind.",
    "Mindful Evolution\nCultivate clinical resilience through beautiful sound sanctuaries, reflective journals, and scientific paths of healing.",
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
