import 'package:flutter/material.dart';
import 'package:school_connect/components/widgets/school_signup.dart';
import 'package:school_connect/components/widgets/volunteer_signup.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0E424C),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0E424C),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'As Volunteer',
              ),
              Tab(
                text: 'Register school',
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            VolunteerSignUpForm(),
            SchoolSignUpForm(),
          ],
        ),
      ),
    );
  }
}
