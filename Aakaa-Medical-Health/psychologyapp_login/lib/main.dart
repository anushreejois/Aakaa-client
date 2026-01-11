import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psychologyapp_login/views/getstarted.dart';

void main() async{
  // Ensure that plugin services are initialized so that `Firebase.initializeApp()` can be called
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: 'AIzaSyBpRNyesakDLooEXC6TzzTkinjeefOvctQ', 
          appId: '1:944267780019:android:8c70d305ac2d2fb286b5c6', 
          messagingSenderId: '944267780019', 
          projectId: 'psychologyapp-login-33bd3',
          ),
      )
      : await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Adding Malgonic Gothic as the default font family
        fontFamily: 'MalgunGothic',
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: const GetStarted(), // Opening the app with get started screen
    );
  }
}

