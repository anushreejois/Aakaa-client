import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'user_controller.dart';

class SignupLoginFunctionality {
  // Backend base URL:
  // - Use 'http://10.0.2.2:5000' for Android Emulator (forwards to host localhost).
  // - Use 'http://localhost:5000' for iOS Simulator or Flutter Web.
  // - Use your computer's local IP address (e.g. 'http://192.168.x.x:5000') for physical test devices.
  static const String backendUrl = "http://10.0.2.2:5000";

  Future<String> signUpUser(String email, String password, String fullName) async {
    try {
      final url = Uri.parse("$backendUrl/api/auth/register");
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.trim(),
          "password": password,
          "fullName": fullName.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return "success";
      } else {
        return data["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return "Connection failed. Please ensure the backend server is running.";
    }
  }

  Future<String> loginUser(String email, String password) async {
    try {
      final url = Uri.parse("$backendUrl/api/auth/login");
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.trim(),
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final userData = data["user"];
        final token = data["token"];

        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);
        
        // Save the authenticated user state to UserController
        UserController.updateUserFromBackend(userData);
        
        return "Login successful";
      } else {
        return data["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return "Connection failed. Please ensure the backend server is running.";
    }
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null || token.isEmpty) {
        return false;
      }

      final url = Uri.parse("$backendUrl/api/users/profile");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == "success") {
        final userData = data["user"];
        UserController.updateUserFromBackend(userData);
        return true;
      } else {
        // Token expired or invalid, clear it
        await prefs.remove("auth_token");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> signOutUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }

  Future<String> updateProfile(String fullName, String avatarUrl, String gender) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null || token.isEmpty) {
        return "Unauthorized. Please log in again.";
      }

      final url = Uri.parse("$backendUrl/api/users/profile");
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "fullName": fullName,
          "avatarUrl": avatarUrl,
          "gender": gender,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == "success") {
        final userData = data["user"];
        UserController.updateUserFromBackend(userData);
        return "success";
      } else {
        return data["message"] ?? "Failed to update profile";
      }
    } catch (e) {
      return "Network connection failed.";
    }
  }
}
