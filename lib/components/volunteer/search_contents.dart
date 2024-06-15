import 'package:flutter/material.dart';

class SearchContents extends StatelessWidget {
  const SearchContents({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: const Color(0xff0E424C),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search schools, subjects..',
              hintFadeDuration: const Duration(seconds: 3),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
    );
  }
}
