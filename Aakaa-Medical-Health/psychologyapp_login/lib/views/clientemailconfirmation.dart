import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:psychologyapp_login/controllers/otpgeneration.dart';
import "package:psychologyapp_login/views/clientlogin.dart";
import "package:psychologyapp_login/controllers/signup_loginfunctionality.dart";

class ClientEmailVerification extends StatefulWidget {
  final String email;
  final String password;
  const ClientEmailVerification({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<ClientEmailVerification> createState() =>
      _ClientEmailVerificationState();
}

class _ClientEmailVerificationState extends State<ClientEmailVerification> {
  final SignupLoginFunctionality signupFunctionality = SignupLoginFunctionality();
  final TextEditingController _firstDigit = TextEditingController();
  final TextEditingController _secondDigit = TextEditingController();
  final TextEditingController _thirdDigit = TextEditingController();
  final TextEditingController _fourthDigit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB3261E),
      appBar: AppBar(
        backgroundColor: Color(0xFFB3261E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFFFFFFF), size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: const Center(
              child: Text(
                "Verification Code",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 38,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 1.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Color(0xFF3E64FF).withOpacity(0.5),
                    spreadRadius: 15,
                    blurRadius: 22.3,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Card(
                elevation: 20,
                color: Color(0xFFFFFFFF),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SizedBox(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 30,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Please enter the code sent to your email",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            widget.email,
                            style: TextStyle(
                              color: Color(0xFFF13C32),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 120,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 75,
                                  height: 55,
                                  child: TextField(
                                    controller: _firstDigit,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Color(0xFFFFE9E8),
                                      hintText: "-",
                                      hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: 75,
                                  height: 55,
                                  child: TextField(
                                    controller: _secondDigit,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Color(0xFFFFE9E8),
                                      hintText: "-",
                                      hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: 75,
                                  height: 55,
                                  child: TextField(
                                    controller: _thirdDigit,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Color(0xFFFFE9E8),
                                      hintText: "-",
                                      hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: 75,
                                  height: 55,
                                  child: TextField(
                                    controller: _fourthDigit,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Color(0xFFFFE9E8),
                                      hintText: "-",
                                      hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 210,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Didn't receive OTP?",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 230,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: TextButton(
                            onPressed: () async {
                              final success = await OTPGeneration.sendOTP(
                                widget.email,
                              );
                              if (success) {
                                await Navigator.pushReplacement(
                                // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ClientEmailVerification(
                                          email: widget.email,
                                          password: widget.password,
                                        ),
                                  ),
                                );
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'OTP sent to ${widget.email}',
                                      ),
                                    ),
                                  );
                              }
                            },
                            child: Text(
                              "Resend Code",
                              style: TextStyle(
                                color: Color(0xFFF46D65),
                                fontSize: 21,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 300,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 280,
                            height: 65,
                            child: ElevatedButton(
                              onPressed: () {
                                String userEnteredOTP =
                                    _firstDigit.text +
                                    _secondDigit.text +
                                    _thirdDigit.text +
                                    _fourthDigit.text;
                                bool verified = OTPGeneration.verifyOTP(
                                  userEnteredOTP,
                                );
                                if (verified) {
                                  signupFunctionality.signUpUser(
                                    widget.email,
                                    widget.password,
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ClientLogin(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Invalid OTP. Please try again.',
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFB3261E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 6,
                              ),
                              child: const Text(
                                "Verify",
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
