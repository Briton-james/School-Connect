import 'package:flutter/material.dart';
import 'dart:async'; // Import for Future.delayed
import 'package:school_connect/screens/welcome_screen.dart'; // Import WelcomeScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1061AD),
      body: Center(
        child: Image.asset(
          'assets/images/book.png',
          width: 200.0,
          height: 200.0,
        ),
      ),
    );
  }
}
