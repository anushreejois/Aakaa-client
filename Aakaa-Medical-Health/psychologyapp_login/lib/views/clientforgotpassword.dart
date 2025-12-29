import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psychologyapp_login/controllers/passwordresetemail.dart';
import 'package:psychologyapp_login/views/clientforpasemailconfirmation.dart';

class ClientForgotPassword extends StatefulWidget {
  const ClientForgotPassword({super.key});

  @override
  State<ClientForgotPassword> createState() => _ClientForgotPasswordState();
}

class _ClientForgotPasswordState extends State<ClientForgotPassword>{

  final _clientForgotPasswordkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  

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
                  "Forgot Password",
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
                                  'assets/images/forgotpassword.png',
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
                              "Forgot Password ?",
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
                              "Please enter your registered email to receive a",
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
                              "confirmation code to set a new password",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000000),
                              ),
                            )
                          )
                        ),
                        Positioned(
                          top: 395,
                          left:0,
                          right: 0,
                          child:Align(
                            alignment: Alignment.topCenter,
                            child: Form(
                              key: _clientForgotPasswordkey,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Email :",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                                              fontSize: 21,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                        ),
                                    ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        controller: emailController,
                                        textAlign: TextAlign.left,
                                        validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter your email';
                                                      }
                                                      if (!RegExp(
                                                        r'^[^@]+@[^@]+\.[^@]+',
                                                      ).hasMatch(value)) {
                                                        return 'Please enter a valid email address';
                                                      }
                                                      return null;
                                                    },
                                        decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      filled: true,
                                                      fillColor: Color(
                                                        0xFFFFE9E8,
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                      ),
                                      SizedBox(height: 60),
                                      Align(
                                                  alignment: Alignment.center,
                                                  child: SizedBox(
                                                    width: 280,
                                                    height: 65,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        if(_clientForgotPasswordkey.currentState!.validate()){
                                                          setState(() {
                                                            showDialog(
                                                                // ignore: deprecated_member_use
                                                                barrierColor: Color(0xFFFFFFFF).withOpacity(0.5),
                                                              // ignore: use_build_context_synchronously
                                                              context: context,
                                                              barrierDismissible: false,
                                                              builder: (context) => const Center(
                                                                child: CircularProgressIndicator(
                                                                  color: Color(0xFFB3261E),
                                                                  strokeWidth: 6.0,
                                                                ),
                                                              )
                                                              );
                                                          });
                                                          final normalizedemail = emailController.text.toLowerCase();
                                                          final query = await FirebaseFirestore.instance.collection('Users').where('Identifier', isEqualTo: normalizedemail).limit(1).get();
                                                          if(query.docs.isNotEmpty){
                                                            final success =
                                                              await PasswordResetEmailController().sendResetEmail(emailController.text);
                                                              if(success == 'OK' ){
                                                            await Future.delayed(Duration(seconds: 2));
                                                            
                                                            Navigator.pop(
                                                              // ignore: use_build_context_synchronously
                                                              context
                                                              );
        
                                                            Navigator.pushReplacement(
                                                              // ignore: use_build_context_synchronously
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ClientForPasEmailVerification(email: emailController.text),
                                                              ),
                                                            );
                                                              }
                                                              else {
                                                            await Future.delayed(Duration(seconds: 2));
                                                            
                                                            Navigator.pop(
                                                              // ignore: use_build_context_synchronously
                                                              context
                                                              );
                                                              
                                                            ScaffoldMessenger.of(
                                                              // ignore: use_build_context_synchronously
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Email confirmation unsuccessful. Please try again later.',
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                            
                                                          }
                                                          else{
                                                            await Future.delayed(Duration(seconds: 2));
                                                            
                                                            Navigator.pop(
                                                              // ignore: use_build_context_synchronously
                                                              context
                                                              );
        
                                                            ScaffoldMessenger.of(
                                                              // ignore: use_build_context_synchronously
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Unrecognized Email. If you are a new user, please signup first',
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Color(
                                                          0xFFB3261E,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        elevation: 6,
                                                      ),
                                                      child: const Text(
                                                        "Confirm Mail",
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFFFFFFFF,
                                                          ),
                                                          fontSize: 28,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                  ],
                                ),
                              ),
                            )
                            )
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
