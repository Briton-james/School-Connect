import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListingsPage extends StatelessWidget {
  const ListingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('listings').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // Cast the data to a Map<String, dynamic> to ensure it matches your expected types
                final Map<String, dynamic>? listingData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>?;

                if (listingData != null) {
                  return ListingInformation(
                    schoolName: listingData['schoolName'] ?? '',
                    description: listingData['description'] ?? '',
                    provideAccommodation:
                        listingData['willProvideAccommodation'] == true,
                    location: listingData['location'] ?? '',
                    numberOfWeeks: listingData['numberOfWeeks'] != null
                        ? listingData['numberOfWeeks'] as int
                        : 0,
                  );
                } else {
                  return Container(); // or any placeholder widget
                }
              },
            );
          }

          return const Center(child: Text('No listings available'));
        },
      ),
    );
  }
}

class ListingInformation extends StatelessWidget {
  final String schoolName;
  final String description;
  final bool provideAccommodation;
  final String location;
  final int numberOfWeeks;

  const ListingInformation({
    Key? key,
    required this.schoolName,
    required this.description,
    required this.provideAccommodation,
    required this.location,
    required this.numberOfWeeks,
  }) : super(key: key);

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
        Text(
          schoolName,
          style: const TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4.0),
        Text(
          description,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            const Icon(Icons.cottage_outlined),
            const SizedBox(
              width: 4.0,
            ),
            Text(
              provideAccommodation
                  ? 'Accommodation provided by the school.'
                  : 'Accommodation not provided.',
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Color(0xFFA0826A),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              location,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 20.0,
            ),
            const Icon(
              Icons.timer_outlined,
              color: Color(0xFFA0826A),
            ),
            const SizedBox(
              width: 4.0,
            ),
            Text(
              '$numberOfWeeks Weeks',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
