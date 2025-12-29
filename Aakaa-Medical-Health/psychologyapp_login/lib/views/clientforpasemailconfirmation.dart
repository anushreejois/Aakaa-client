import "package:flutter/material.dart";
import "package:psychologyapp_login/controllers/signup_loginfunctionality.dart";

class ClientForPasEmailVerification extends StatefulWidget {
  final String email;
  const ClientForPasEmailVerification({
    super.key,
    required this.email,
  });

  @override
  State<ClientForPasEmailVerification> createState() =>
      _ClientForPasEmailVerificationState();
}

class _ClientForPasEmailVerificationState extends State<ClientForPasEmailVerification> {
  final SignupLoginFunctionality signupFunctionality = SignupLoginFunctionality();

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

      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: const Center(
                child: Text(
                  "Verify email address",
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
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 250,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Color(0xFF3E64FF).withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 5,
                                    offset: Offset(
                                      5,
                                      5,
                                    ), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/otp_auth.png',
                                  fit: BoxFit.fill,
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
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Verify email address",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000000),
                              ),
                            )
                          )
                        ),
                        Positioned(
                          top: 335,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              " The verification mail has been sent to",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000000),
                              ),
                            )
                          )
                        ),
                        Positioned(
                          top: 350,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              widget.email,
                              style: TextStyle(
                                color: Color(0xFFF13C32),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
