import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1061AD),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: ListView(
            children: [
              Image.asset(
                'assets/images/book.png',
                width: 100.0,
                height: 100.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                    text: 'School',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(children: [
                    TextSpan(
                      text: 'Connect',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ])
                ])),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'Reset password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  //decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'New password',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm new password',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Code sent in your email',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  //login logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 40.0),
                ),
                child: const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
