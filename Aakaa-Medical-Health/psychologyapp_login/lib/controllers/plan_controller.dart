import 'package:flutter/material.dart';

class PlanController {
  // Mocking the user plan status
  // Set to 'false' initially to demonstrate the "Locked" state
  static bool isPremiumMember = false;

  static String currentPlan = "Freemium";

  static void upgradeToPremium() {
    isPremiumMember = true;
    currentPlan = "Premium";
  }
}
