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
        title: "Plan Unlocked",
        body: "Welcome to Aakaa ${planNameNotifier.value}! All advanced sanctuaries and therapist features are now open.",
        iconType: "premium",
      );
    }
  }

  static void upgradeToPremium() {
    selectPlan(3);
  }
}
