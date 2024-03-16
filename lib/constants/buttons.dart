import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  get buttonAction => null;

  String? get buttonText => null;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:
      ElevatedButton(
        onPressed: buttonAction,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          minimumSize: const Size(150, 50),
        ),
        child: Text(
          buttonText!,
          style: const TextStyle(
            fontSize: 18.0, // Change button text size
            color: Colors.black, // Change button text color
          ),
        ),
      ),
    );
  }
}
