import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SchoolHomeContents extends StatelessWidget {
  const SchoolHomeContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final currentUserUID = snapshot.data?.uid;

        if (currentUserUID == null) {
          // No user is logged in
          return const Center(child: Text('No user logged in'));
        }

        return _buildListings(currentUserUID);
      },
    );
  }

  Widget _buildListings(String currentUserUID) {
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('listings')
            .where('uid', isEqualTo: currentUserUID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No listings available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              final listingData = document.data() as Map<String, dynamic>;

              return Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 300.0),
                child: Card(
                  color: const Color(0xFF0E424C),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/chamazi.jpg',
                                width: 60.0,
                                height: 60.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                listingData['description']?.toString() ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Text(
                              listingData['schoolName']?.toString() ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xffA0826A),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              listingData['region']?.toString() ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 8.0),
                            const Icon(
                              Icons.timer_outlined,
                              color: Color(0xffA0826A),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '${listingData['numberOfWeeks']?.toString() ?? 0} Week(s)',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.apartment_outlined,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              listingData['willProvideAccommodation'] == true
                                  ? 'Accommodation provided by school'
                                  : 'No accommodation',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status: ${listingData['status']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            Switch(
                              value: listingData['status'] == 'ongoing',
                              onChanged: (value) {
                                _confirmStatusChange(
                                    context, document.id, value);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmStatusChange(
      BuildContext context, String listingId, bool isOngoing) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Status Change'),
          content: Text(
            isOngoing
                ? 'Are you sure you want to change the status to "ongoing"?'
                : 'Are you sure you want to change the status to "ended"?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                _updateListingStatus(
                    listingId, isOngoing ? 'ongoing' : 'ended');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateListingStatus(String listingId, String status) async {
    await FirebaseFirestore.instance
        .collection('listings')
        .doc(listingId)
        .update({'status': status});
  }
}
