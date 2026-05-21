import 'package:flutter/material.dart';
import 'notification_controller.dart';

class PlanController {
  // Global reactive state for premium subscription
  static final ValueNotifier<bool> premiumNotifier = ValueNotifier<bool>(false);
  static final ValueNotifier<String> planNameNotifier = ValueNotifier<String>("Freemium");
  static final ValueNotifier<int> planIndexNotifier = ValueNotifier<int>(0);

  static bool get isPremiumMember => premiumNotifier.value;
  static String get currentPlan => planNameNotifier.value;
  static int get currentPlanIndex => planIndexNotifier.value;

  // Plan pricing labels
  static String getPlanPrice(int index) {
    switch (index) {
      case 0: return "Free";
      case 1: return "₹199/mo";
      case 2: return "₹399/mo";
      case 3: return "₹799/mo";
      default: return "Free";
    }
  }

  // Value-Add Feature Authorization Mappings
  static bool get isCaretakerAllowed => planIndexNotifier.value >= 1;
  static bool get isVentLoungeAllowed => planIndexNotifier.value >= 1;
  static bool get isSleepMixerAllowed => planIndexNotifier.value >= 1;
  static bool get isJournalAnalysisAllowed => planIndexNotifier.value >= 1;
  
  // Journal Analysis Limits
  static int get maxJournalAnalysesPerMonth {
    if (planIndexNotifier.value == 0) return 0;
    if (planIndexNotifier.value == 1) return 5;
    return 99999; // Unlimited for Standard & Premium
  }

  // Therapist-Integration Authorization Mappings
  static bool get isDirectMessagingAllowed => planIndexNotifier.value >= 2;
  static bool get isCbtDataSharingAllowed => planIndexNotifier.value >= 2;
  static bool get isClinicalReportAllowed => planIndexNotifier.value >= 2;
  
  static double get sessionDiscountRate {
    if (planIndexNotifier.value == 2) return 0.10; // 10% off for Standard
    if (planIndexNotifier.value == 3) return 0.15; // 15% off for Premium
    return 0.0;
  }

  static bool get hasFreeSession => planIndexNotifier.value == 3; // 1 Free session for Premium
  static bool get isEmergencyLineAllowed => planIndexNotifier.value == 3; // Emergency Grounding Line

  static void selectPlan(int index) {
    planIndexNotifier.value = index;
    if (index == 0) {
      premiumNotifier.value = false;
      planNameNotifier.value = "Freemium";
    } else if (index == 1) {
      premiumNotifier.value = true;
      planNameNotifier.value = "Basic";
    } else if (index == 2) {
      premiumNotifier.value = true;
      planNameNotifier.value = "Standard";
    } else if (index == 3) {
      premiumNotifier.value = true;
      planNameNotifier.value = "Premium";
    }

    if (index > 0) {
      NotificationController.addNotification(
        title: "Plan Unlocked 🌟",
        body: "Welcome to Aakaa ${planNameNotifier.value}! All authorized caretaker and therapist features are now open.",
        iconType: "premium",
      );
    }
  }

  static void upgradeToPremium() {
    selectPlan(3);
  }
}

