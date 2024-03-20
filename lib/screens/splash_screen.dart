import 'package:flutter/material.dart';
import 'package:school_connect/screens/welcome_screen.dart';
import 'dart:async';

import 'home_screen.dart'; // Import for Future.delayed


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1061AD),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/book.png',
              height: 150.0,
                width: 150.0,
              ),

              const SizedBox(
                height: 20.0,
              ),

              RichText(text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'School',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    TextSpan(
                        children: [
                          TextSpan(
                            text: 'Connect',
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                          ),
                        ]
                    )
                  ]
              )
              ),
            ]
        ),
      ),
    );
  }
}
