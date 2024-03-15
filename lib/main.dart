import 'package:flutter/material.dart';
import 'package:school_connect/screens/splash_screen.dart';
import 'package:school_connect/screens/welcome_screen.dart'; // Import WelcomeScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Connect', // Optional app title
      home: SplashScreen(), // Initial screen
    );
  }
}
