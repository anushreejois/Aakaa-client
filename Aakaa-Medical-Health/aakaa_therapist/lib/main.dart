import 'package:flutter/material.dart';
import 'views/therapist_getstarted.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aakaa Caregiver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF065643),
          primary: const Color(0xFF065643),
          secondary: const Color(0xFF0A7D62),
          surface: const Color(0xFFFFF7F5),
        ),
        useMaterial3: true,
      ),
      home: const TherapistGetStarted(),
    );
  }
}
