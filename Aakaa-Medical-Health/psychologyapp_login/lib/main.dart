import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/views/getstarted.dart';

void main() async{
  // Ensure that plugin services are initialized so that `Firebase.initializeApp()` can be called
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBpRNyesakDLooEXC6TzzTkinjeefOvctQ', 
          appId: '1:944267780019:android:8c70d305ac2d2fb286b5c6', 
          messagingSenderId: '944267780019', 
          projectId: 'psychologyapp-login-33bd3',
          ),
      )
      : await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aakaa',
      theme: ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadePageTransitionsBuilder(),
            TargetPlatform.iOS: FadePageTransitionsBuilder(),
          },
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF065643),
          primary: const Color(0xFF065643),
          onPrimary: const Color(0xFFFFF7F5),
          secondary: const Color(0xFF0A7D62),
          surface: const Color(0xFFFFF7F5),
          onSurface: const Color(0xFF000000),
          error: const Color(0xFFB00020),
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFFFF7F5),
        
        // Premium iOS-style Card Theme
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          color: Colors.white.withValues(alpha: 0.8),
        ),
        
        // Premium Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // Input Decoration Theme for a clean iOS look
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFF7F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF065643), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const GetStarted(),
    );
  }
}

class FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
