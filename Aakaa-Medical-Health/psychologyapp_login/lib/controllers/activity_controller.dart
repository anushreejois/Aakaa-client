import 'package:flutter/material.dart';

class ActivityController {
  // Mock Data (To be replaced with Firestore logic later)
  static const int sessionCount = 14;
  static const int moodLogCount = 32;
  static const double growthPercentage = 0.88;
  
  static const String joinDate = "May 10";
  static const String firstSessionDate = "May 12";
  static const String currentStreak = "12 Day Streak";

  // Mock Mood History (0 to 4 scale)
  static final List<Map<String, dynamic>> moodHistory = [
    {"day": "Mon", "value": 3, "mood": "Good"},
    {"day": "Tue", "value": 2, "mood": "Okay"},
    {"day": "Wed", "value": 4, "mood": "Great"},
    {"day": "Thu", "value": 3, "mood": "Good"},
    {"day": "Fri", "value": 4, "mood": "Great"},
    {"day": "Sat", "value": 4, "mood": "Great"},
    {"day": "Sun", "value": 3, "mood": "Good"},
  ];

  // Growth Journey Milestones
  static final List<Map<String, String>> milestones = [
    {"title": "Joined Aakaa", "date": joinDate, "icon": "stars"},
    {"title": "First Session", "date": firstSessionDate, "icon": "verified"},
    {"title": "Deep Focus", "date": "June 05", "icon": "self_improvement"},
    {"title": "Mindfulness Master", "date": "June 20", "icon": "workspace_premium"},
  ];

  // Helper to get formatted growth
  static String get formattedGrowth => "${(growthPercentage * 100).toInt()}%";

  // Future: Add methods to fetch data from Firestore
  /*
  static Future<Map<String, dynamic>> fetchUserStats(String email) async {
    // Firestore fetching logic here
  }
  */
}
