import 'dart:convert';
import 'package:http/http.dart' as http;
import 'signup_loginfunctionality.dart';

class OTPGeneration {
  // Send OTP from the backend using Nodemailer SMTP
  static Future<bool> sendOTP(String email) async {
    try {
      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/auth/send-otp");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.trim().toLowerCase()}),
      );

      final data = jsonDecode(response.body);
      return response.statusCode == 200 && data["status"] == "success";
    } catch (e) {
      return false;
    }
  }

  // Verify OTP entered by user against the backend session
  static Future<bool> verifyOTP(String email, String enteredOTP) async {
    try {
      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/auth/verify-otp");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.trim().toLowerCase(),
          "otp": enteredOTP.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      return response.statusCode == 200 && data["status"] == "success";
    } catch (e) {
      return false;
    }
  }
}
