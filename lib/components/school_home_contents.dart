import 'package:flutter/material.dart';

import 'application_sheet.dart';

class SchoolHomeContents extends StatelessWidget {
  const SchoolHomeContents({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: 4, // Replace with your data source length
        itemBuilder: (context, index) => Container(
          width: double.infinity, // Allow max width within constraints
          constraints: const BoxConstraints(maxWidth: 300.0), //Max card width
          child: Card(
            color: const Color(0xFF0E424C), // Card background color
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // Main column for three-row layout
                children: [
                  Row(
                    // First row: image and paragraph
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(8.0), // Image border radius
                        child: Image.asset(
                          'assets/images/chamazi.jpg',
                          width: 80.0, // Adjust image width
                          height: 80.0, // Adjust image height
                          fit: BoxFit.cover, // Scale image to fill container
                        ),
                      ),
                      const SizedBox(
                          width: 16.0), // Spacing between image and text
                      const Expanded(
                        child: Text(
                          'In need of 4 teachers for Chemistry, Mathematics, Biology and Geography, one teacher each.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0), // Spacing between rows
                  const Row(
                    // Second row: bold text aligned left
                    children: [
                      Text(
                        'Mbande secondary school',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0), // Spacing between rows
                  Row(
                    // Third row: icons with text and button, aligned to the right
                    mainAxisAlignment: MainAxisAlignment.end, // Align to right
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const SizedBox(width: 8.0), // Spacing between icons
                      const Text(
                        'Chamazi',
                        style: TextStyle(color: Colors.white),
                      ), // Text label for icon
                      const SizedBox(
                          width: 8.0), // Spacing between text and icon
                      const Icon(Icons.timer_outlined),
                      const SizedBox(width: 8.0), // Spacing between icons
                      const Text(
                        '3 Months',
                        style: TextStyle(color: Colors.white),
                      ), // Text label for icon
                      const SizedBox(
                          width: 8.0), // Spacing between text and button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA0826A)),
                        onPressed: () => (showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => const ApplicationSheet())),
                        child: const Text('End applications'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
