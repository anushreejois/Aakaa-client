import 'package:flutter/material.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String gender;
  final String email;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    required this.gender,
    required this.email,
  });

  String get fullName => "$firstName $lastName";

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? gender,
    String? email,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      email: email ?? this.email,
    );
  }
}

class UserController {
  // Global reactive state notifier for the current user
  static final ValueNotifier<UserModel> userNotifier = ValueNotifier<UserModel>(
    UserModel(
      firstName: "Anushree",
      lastName: "Jois",
      avatarUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop",
      gender: "Female",
      email: "anushree@aakaa.com",
    ),
  );

  static final ValueNotifier<String> languageNotifier = ValueNotifier<String>("English");

  static UserModel get currentUser => userNotifier.value;
  static String get currentLanguage => languageNotifier.value;

  static void updateProfile({
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? gender,
    String? email,
  }) {
    userNotifier.value = userNotifier.value.copyWith(
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
      gender: gender,
      email: email,
    );
  }

  static void updateEmail(String newEmail, {String? fullName}) {
    String derivedFirst = userNotifier.value.firstName;
    String derivedLast = userNotifier.value.lastName;

    if (fullName != null && fullName.trim().isNotEmpty) {
      final parts = fullName.trim().split(' ');
      derivedFirst = parts.first;
      if (parts.length > 1) {
        derivedLast = parts.sublist(1).join(' ');
      }
    } else {
      String splitFirst = newEmail.split('@').first;
      if (splitFirst.isNotEmpty) {
        derivedFirst = splitFirst[0].toUpperCase() + splitFirst.substring(1);
      }
    }

    userNotifier.value = userNotifier.value.copyWith(
      email: newEmail,
      firstName: derivedFirst,
      lastName: derivedLast,
    );
  }

  static void updateLanguage(String newLang) {
    languageNotifier.value = newLang;
  }
}
