import 'package:flutter/material.dart';

class ListingInformation extends StatelessWidget {
  const ListingInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.asset(
            'assets/images/chamazi.jpg',
            width: 40.0,
            height: 40.0,
            fit: BoxFit.cover,
          ),
        ),
        const Text(
          'Chamazi Sec. School',
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4.0),
        const Text(
          'In need of 4 teachers for Chemistry, Mathematics, Biology and Geography, one teacher each.',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16.0),
        const Row(
          children: [
            Icon(Icons.cottage_outlined),
            SizedBox(
              width: 4.0,
            ),
            Text(
              'Accommodation provided by the school.',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        const Row(
          children: [
            Icon(
              Icons.location_on_outlined,
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              'Chamazi',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 20.0,
            ),
            Icon(Icons.timer_outlined),
            SizedBox(
              width: 4.0,
            ),
            Text(
              '2 Months',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
