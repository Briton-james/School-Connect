import 'package:flutter/material.dart';
import 'package:school_connect/components/volunteer/profile_contents.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your profile"),
      ),
      backgroundColor: const Color(0xFF0E424C),
      body: const ProfileContents(),
    );
  }
}
