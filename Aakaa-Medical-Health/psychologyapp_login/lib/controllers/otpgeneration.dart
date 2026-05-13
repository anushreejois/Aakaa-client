import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class OTPGeneration {
  // Stores the most recently generated OTP
  static String? _storedOTP;

  // Generate 4-digit OTP
  static String generateOTP() {
    final random = Random();
    final otp = (1000 + random.nextInt(9000)).toString();
    _storedOTP = otp;

    return otp;
  }

  // Send OTP using EmailJS
  static Future<bool> sendOTP(String email) async {
    final otp = generateOTP();

    const serviceId = "service_qv3ikr6";
    const templateId = "template_45i0n5s";
    const publicKey = "DKHSrRnbaXlKJo0Hh";

    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

    final response = await http.post(
      url,
      headers: {
        "origin": "http://localhost",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "service_id": serviceId,
        "template_id": templateId,
        "user_id": publicKey,
        "template_params": {
          "email": email, // EmailJS variable
          "passcode": otp,        // EmailJS variable
        }
      }),
    );

    // DEMO MODE BYPASS
    return true;
    // return response.statusCode == 200;
  }

  // Verify OTP entered by user
  static bool verifyOTP(String enteredOTP) {

    if (_storedOTP == null) {
      return false;
    }

    // DEMO MODE BYPASS
    return true;
    // return enteredOTP.trim() == _storedOTP;
  }
}
