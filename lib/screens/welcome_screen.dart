import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'volunteer_home.dart'; // Import SignInScreen

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentSlideIndex = 0;
  final _slideDuration = const Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    // Timer for auto-sliding (optional)
    Timer.periodic(_slideDuration, (_) {
      setState(() {
        _currentSlideIndex = (_currentSlideIndex + 1) % 3; // Wrap around
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = [
      _buildSlide(
        image: 'assets/images/connect.png',
        title: 'Welcome to School Connect!',
        description:
            'We connect graduates to schools for volunteering in teaching.',
        buttonText: 'Continue',
        buttonAction: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const VolunteerHomeScreen())),
      ),
      _buildSlide(
        image: 'assets/images/teaching.png',
        title: 'Get Practical Experience.',
        description:
            'Shape your teaching career by gaining a practical experience in teaching.',
        buttonText: 'Continue',
        buttonAction: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const VolunteerHomeScreen())),
      ),
      _buildSlide(
        image: 'assets/images/certificate.png',
        title: 'Build your profile.',
        description:
            'Get recognized by a certificate of recognition when you volunteer.',
        buttonText: 'Continue',
        buttonAction: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const VolunteerHomeScreen())),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1061AD),
      body: Stack(
        children: [
          CarouselSlider(
            items: slides.map((widget) => widget).toList(),
            options: CarouselOptions(
              height: double.infinity, // Occupy entire screen height
              viewportFraction: 1.0, // Show entire slide
              autoPlay: true, // Enable auto-play
              autoPlayInterval: _slideDuration, // Auto-slide duration
              autoPlayAnimationDuration:
                  const Duration(milliseconds: 800), // Smooth transition
              onPageChanged: (index, reason) =>
                  setState(() => _currentSlideIndex = index),
            ),
          ),
          Positioned(
            bottom: 80.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < slides.length; i++)
                  CustomIndicator(
                    color: _currentSlideIndex == i
                        ? const Color(0XFFF68E1E)
                        : const Color(0xFF6810AD), // Updated color handling
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide({
    required String image,
    required String title,
    required String description,
    String buttonText = '',
    VoidCallback? buttonAction,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        // Closing parenthesis added here
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 200.0,
            height: 200.0,
          ),
          const SizedBox(height: 20.0),
          Text(
            title,
            style: const TextStyle(
                fontSize: 22.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            description,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60.0),
          if (buttonText.isNotEmpty) // Only show button if text is provided
            ElevatedButton(
              onPressed: buttonAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(150, 50),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 18.0, // Change button text size
                  color: Colors.black, // Change button text color
                ),
              ),
            ),
        ],
      ),
    );
  }
}

//Creating a custom dot indicator for the slides.
class CustomIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const CustomIndicator({super.key, required this.color, this.size = 10.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
