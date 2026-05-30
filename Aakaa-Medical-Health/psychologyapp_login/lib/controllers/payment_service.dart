import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_loginfunctionality.dart';
import 'user_controller.dart';

class PaymentService {
  static final Razorpay _razorpay = Razorpay();
  static bool _isInitialized = false;

  static Function(String)? _onPaymentSuccessCallback;
  static Function(String)? _onPaymentErrorCallback;

  static void initialize() {
    if (_isInitialized) return;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _isInitialized = true;
  }

  static void dispose() {
    _razorpay.clear();
    _isInitialized = false;
  }

  static void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final String? paymentId = response.paymentId;
    final String? orderId = response.orderId;
    final String? signature = response.signature;

    if (paymentId == null || orderId == null || signature == null) {
      _onPaymentErrorCallback?.call("Payment metadata is incomplete.");
      return;
    }

    _onPaymentSuccessCallback?.call(jsonEncode({
      "razorpay_payment_id": paymentId,
      "razorpay_order_id": orderId,
      "razorpay_signature": signature,
    }));
  }

  static void _handlePaymentError(PaymentFailureResponse response) {
    final String errorMsg = response.message ?? "Payment failed or cancelled.";
    _onPaymentErrorCallback?.call(errorMsg);
  }

  static void _handleExternalWallet(ExternalWalletResponse response) {
    _onPaymentErrorCallback?.call("External wallet selected: ${response.walletName}");
  }

  static Future<void> startPayment({
    required double amount,
    required String purpose,
    int? planIndex,
    required BuildContext context,
    required Function(String successPayload) onSuccess,
    required Function(String errorMsg) onFailure,
  }) async {
    initialize();
    _onPaymentSuccessCallback = onSuccess;
    _onPaymentErrorCallback = onFailure;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      if (token == null || token.isEmpty) {
        onFailure("Authentication session expired. Please log in again.");
        return;
      }

      // 1. Create order on Node.js backend
      final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/payments/create-order");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "amount": amount,
          "purpose": purpose,
          "planIndex": planIndex,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200 || data["status"] != "success") {
        onFailure(data["message"] ?? "Failed to initialize secure payment order.");
        return;
      }

      final String orderId = data["orderId"];
      final String keyId = data["keyId"];
      final int actualAmount = data["amount"]; // In paise

      // 2. Open Razorpay Native Checkout Sheet
      final user = UserController.currentUser;
      final options = {
        'key': keyId,
        'amount': actualAmount,
        'name': 'Aakaa Mental Health',
        'order_id': orderId,
        'description': purpose == 'subscription' ? 'Subscription Upgrade' : 'Therapist Consultation Booking',
        'timeout': 300,
        'prefill': {
          'contact': '9999999999',
          'email': user.email,
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      _razorpay.open(options);
    } catch (e) {
      onFailure("Error establishing connection to payment server.");
    }
  }

  static Future<void> startSubscriptionPayment({
    required int planIndex,
    required double amount,
    required BuildContext context,
    required VoidCallback onComplete,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF065643)),
      ),
    );

    await startPayment(
      amount: amount,
      purpose: "subscription",
      planIndex: planIndex,
      context: context,
      onSuccess: (successPayload) async {
        Navigator.pop(context); // Close loading spinner
        
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Color(0xFF065643)),
          ),
        );

        try {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString("auth_token");
          
          final url = Uri.parse("${SignupLoginFunctionality.backendUrl}/api/payments/verify-subscription");
          
          final payload = jsonDecode(successPayload);
          payload["planIndex"] = planIndex;

          final response = await http.post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            },
            body: jsonEncode(payload),
          );

          final verifyData = jsonDecode(response.body);
          Navigator.pop(context); // Close verification spinner

          if (response.statusCode == 200 && verifyData["status"] == "success") {
            UserController.updateUserFromBackend(verifyData["user"]);
            onComplete();
          } else {
            _showErrorSnackBar(context, verifyData["message"] ?? "Payment verification failed.");
          }
        } catch (e) {
          Navigator.pop(context); // Close spinner
          _showErrorSnackBar(context, "Verification server connection failed.");
        }
      },
      onFailure: (errorMsg) {
        Navigator.pop(context); // Close loading spinner
        _showErrorSnackBar(context, errorMsg);
      },
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
