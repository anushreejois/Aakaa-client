import "package:flutter/material.dart";
import "package:psychologyapp_login/controllers/signup_loginfunctionality.dart";
import "package:psychologyapp_login/controllers/togglebutton.dart";
import "package:psychologyapp_login/views/clientemailconfirmation.dart";
import "package:psychologyapp_login/views/clientforgotpassword.dart";
import "package:psychologyapp_login/controllers/otpgeneration.dart";
import "package:psychologyapp_login/views/clientnavigationbar.dart";

class ClientLogin extends StatefulWidget {
  const ClientLogin({super.key});

  @override
  State<ClientLogin> createState() => _ClientLoginState();
}

class _ClientLoginState extends State<ClientLogin> {
  final SignupLoginFunctionality signupFunctionality = SignupLoginFunctionality();
  bool isLogin = true;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool isLoginPasswordVisible = false;
  bool isSignUpPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  late String loginemail;
  late String loginpassword;
  final TextEditingController signinemail = TextEditingController();
  late String signinpassword;
  final TextEditingController signinconfirmpassword = TextEditingController();
  bool onTap = false;

  bool isLoading = false;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Center(
                child: Icon(Icons.person, color: Color(0xFFFFFFFF), size: 100),
              ),
            ),
            SizedBox(height: 40),
            Container(
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
                        top: 20,
                        left: 0,
                        right: 0,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 50),
                          child: isLogin
                              ? Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Hi!! Welcome back, you have been missed:)",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Fill your information below:)",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        top: 60,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              SlidingToggleButton(
                                isLogin: isLogin,
                                onToggle: (value) {
                                  setState(() {
                                    isLogin = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 30),

                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 0),
                                child: isLogin
                                    ? Form(
                                        key: _loginFormKey,
                                        child: Container(
                                          key: ValueKey("Log-in"),
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.75,
                                          padding: const EdgeInsets.all(6),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Email :",
                                                  style: TextStyle(
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: TextFormField(
                                                  onChanged: (value) {
                                                    loginemail = value;
                                                  },
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
                                              ),
                                              SizedBox(height: 20),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Password :",
                                                  style: TextStyle(
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: TextFormField(
                                                  onChanged: (value) {
                                                    loginpassword = value;
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter your password';
                                                    }
                                                    if (value.length < 6) {
                                                      return 'Password must at least be 6 characters';
                                                    }
                                                    if (!RegExp(
                                                      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).+$',
                                                    ).hasMatch(value)) {
                                                      return 'Password must include atleast:\n 1 uppercase\n 1 lowercase\n 1 number\n 1 special character';
                                                    }
                                                    return null;
                                                  },
                                                  maxLength: 12,
                                                  decoration: InputDecoration(
                                                    suffix: SizedBox(
                                                      height: 28,
                                                      child: IconButton(
                                                        icon: Icon(
                                                          isLoginPasswordVisible
                                                              ? Icons.visibility
                                                              : Icons
                                                                    .visibility_off,
                                                          color: Color(
                                                            0xFF000000,
                                                            // ignore: deprecated_member_use
                                                          ).withOpacity(0.5),
                                                          size: 18,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            isLoginPasswordVisible =
                                                                !isLoginPasswordVisible;
                                                          });
                                                        },
                                                        color: Color(
                                                          0xFF000000,
                                                        ),
                                                      ),
                                                    ),
                                                    border: InputBorder.none,
                                                    filled: true,
                                                    fillColor: Color(
                                                      0xFFFFE9E8,
                                                    ),
                                                  ),
                                                  obscureText:
                                                      !isLoginPasswordVisible,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      onTap = true;
                                                    });
                                                    if(onTap = true){
                                                      await Future.delayed(Duration(milliseconds: 500));
                                                    Navigator.push(
                                                      // ignore: use_build_context_synchronously
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ClientForgotPassword(),
                                                      ),
                                                    );
                                                    setState(() {
                                                      onTap = false;
                                                    });
                                                    }
                                                  },
                                                  child: Text(
                                                    "Forgotten password ?",
                                                    style: TextStyle(
                                                      color: onTap ? Color(0xFFB3261E):Color(0xFF000000),
                                                      fontSize: 16,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 100),
                                              Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  width: 280,
                                                  height: 65,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (_loginFormKey
                                                          .currentState!
                                                          .validate()) {
                                                            setState(() {
                                                            isLoading = true;
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
                                                        String res =
                                                            await signupFunctionality.loginUser(loginemail, loginpassword);
                                                        if (res == "Login successful") {
                                                          
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
                                                                  ClientNavigationBar(),
                                                            ),
                                                          );
                                                        } else {
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
                                                                'Login was unsuccessful.',
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
                                                      "Log-in",
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
                                    : Form(
                                        key: _signUpFormKey,
                                        child: Container(
                                          key: ValueKey("Sign-up"),
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.75,
                                          padding: const EdgeInsets.all(6),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Email :",
                                                  style: TextStyle(
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: TextFormField(
                                                  controller: signinemail,
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
                                              ),
                                              SizedBox(height: 20),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Password :",
                                                  style: TextStyle(
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: TextFormField(
                                                  onChanged: (value) {
                                                    signinpassword = value;
                                                  },
                                                  controller:
                                                      _passwordController,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter your password';
                                                    }
                                                    if (value.length < 6) {
                                                      return 'Password must at least be 6 characters';
                                                    }
                                                    if (!RegExp(
                                                      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).+$',
                                                    ).hasMatch(value)) {
                                                      return 'Password must include atleast:\n 1 uppercase\n 1 lowercase\n 1 number\n 1 special character';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    suffix: SizedBox(
                                                      height: 28,
                                                      child: IconButton(
                                                        icon: Icon(
                                                          isSignUpPasswordVisible
                                                              ? Icons.visibility
                                                              : Icons
                                                                    .visibility_off,
                                                          color: Color(
                                                            0xFF000000,
                                                            // ignore: deprecated_member_use
                                                          ).withOpacity(0.5),
                                                          size: 18,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            isSignUpPasswordVisible =
                                                                !isSignUpPasswordVisible;
                                                          });
                                                        },
                                                        color: Color(
                                                          0xFF000000,
                                                        ),
                                                      ),
                                                    ),
                                                    border: InputBorder.none,
                                                    filled: true,
                                                    fillColor: Color(
                                                      0xFFFFE9E8,
                                                    ),
                                                  ),
                                                  obscureText:
                                                      !isSignUpPasswordVisible,
                                                  maxLength: 12,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Confirm Password :",
                                                  style: TextStyle(
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: TextFormField(
                                                  controller:
                                                      signinconfirmpassword,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please confirm your password';
                                                    }
                                                    if (value !=
                                                        _passwordController
                                                            .text) {
                                                      return 'Passwords do not match';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    suffix: SizedBox(
                                                      height: 28,
                                                      child: IconButton(
                                                        icon: Icon(
                                                          isConfirmPasswordVisible
                                                              ? Icons.visibility
                                                              : Icons
                                                                    .visibility_off,
                                                          color: Color(
                                                            0xFF000000,
                                                            // ignore: deprecated_member_use
                                                          ).withOpacity(0.5),
                                                          size: 18,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            isConfirmPasswordVisible =
                                                                !isConfirmPasswordVisible;
                                                          });
                                                        },
                                                        color: Color(
                                                          0xFF000000,
                                                        ),
                                                      ),
                                                    ),
                                                    border: InputBorder.none,
                                                    filled: true,
                                                    fillColor: Color(
                                                      0xFFFFE9E8,
                                                    ),
                                                  ),
                                                  obscureText:
                                                      !isConfirmPasswordVisible,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 50),
                                              Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  width: 280,
                                                  height: 65,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (_signUpFormKey
                                                          .currentState!
                                                          .validate()) {
                                                            setState(() {
                                                            isLoading = true;
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
                                                        final success =
                                                            await OTPGeneration.sendOTP(
                                                              signinemail.text,
                                                            );
                                                        if (success) {
                                                          
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
                                                                  ClientEmailVerification(
                                                                    email:
                                                                        signinemail
                                                                            .text,
                                                                    password:
                                                                        signinconfirmpassword
                                                                            .text,
                                                                  ),
                                                            ),
                                                          );
                                                        } else {
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
                                                                'Invalid OTP. Please try again.',
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
                                                      "Sign-up",
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
                                      ),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ],
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
