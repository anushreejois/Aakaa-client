import 'package:flutter/material.dart';

class PageSlide {
  final  pageController = PageController();
  int currentPage = 0;

  final List<String> infoTexts = [ 
    "Info One",
    "Info Two",
    "Info Three",
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
