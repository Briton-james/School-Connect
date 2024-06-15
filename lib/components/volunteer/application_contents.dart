import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApplicationContents extends StatelessWidget {
  const ApplicationContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('volunteerUID', isEqualTo: user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text(
            'Your applications will appear here',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final applicationDocument = snapshot.data!.docs[index];
            final applicationData =
                applicationDocument.data() as Map<String, dynamic>;

            final listingID = applicationData['listingUID'] ?? '';
            final status = applicationData['status'] ?? 'Unknown';
            final List<dynamic>? subjects = applicationData['subjects'];

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('listings')
                  .doc(listingID)
                  .snapshots(),
              builder: (context, listingSnapshot) {
                if (listingSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }

                if (listingSnapshot.hasError) {
                  return Center(child: Text('Error: ${listingSnapshot.error}'));
                }

                final listingData =
                    listingSnapshot.data!.data() as Map<String, dynamic>?;

                final schoolName = listingData?['schoolName'] ?? 'Unknown';
                final description = listingData?['description'] ?? 'Unknown';
                final location = listingData?['location'] ?? 'Unknown';
                final numberOfWeeks =
                    listingData?['numberOfWeeks'] ?? 'Unknown';
                final listingSubjects =
                    (listingData?['subjects'] as List<dynamic>? ?? [])
                        .cast<String>();

                return Card(
                  color: const Color(0xff0E424C),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schoolName,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          description,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xffA0826A),
                            ),
                            const SizedBox(width: 4.0),
                            Text(location,
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: Color(0xffA0826A),
                            ),
                            const SizedBox(width: 4.0),
                            Text('$numberOfWeeks Weeks',
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Text(
                              'Subjects:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              subjects != null
                                  ? subjects.join(', ')
                                  : 'Unknown',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            const Text('Application status:',
                                style: TextStyle(color: Colors.white)),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: status == 'Accepted'
                                    ? Colors.green
                                    : (status == 'Rejected'
                                        ? Colors.red
                                        : const Color(0xffA0826A)),
                              ),
                              child: Text(status),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
