import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'application_sheet.dart';

class HomeContents extends StatelessWidget {
  const HomeContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('listings')
            .where('status', isEqualTo: 'ongoing')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final document = snapshot.data!.docs[index];
                final listingID = document.id; // Get the document ID

                // Type check and cast listing data
                final listingData = document.data() as Map<String, dynamic>?;
                if (listingData == null) {
                  // handle the case where document.data() is null
                  return const Text('Error retrieving listing data');
                }

                // Extract other listing data
                final schoolUID = listingData['uid']?.toString() ?? '';
                final description =
                    listingData['description']?.toString() ?? '';
                final schoolName = listingData['schoolName']?.toString() ?? '';
                final region = listingData['region']?.toString() ?? '';
                final numberOfWeeks =
                    listingData['numberOfWeeks']?.toString() ?? '';
                final willProvideAccommodation =
                    listingData['willProvideAccommodation'] ?? false;

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('schools')
                      .doc(schoolUID)
                      .get(),
                  builder: (context, schoolSnapshot) {
                    if (schoolSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return LoadingAnimationWidget.beat(
                          color: const Color(0xffA0826A), size: 20);
                    }

                    if (schoolSnapshot.hasError) {
                      return Text('Error: ${schoolSnapshot.error}');
                    }

                    final schoolData =
                        schoolSnapshot.data?.data() as Map<String, dynamic>?;
                    final profileImageUrl =
                        schoolData?['profileImageUrl']?.toString();

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
                                    child: profileImageUrl != null
                                        ? Image.network(
                                            profileImageUrl,
                                            width: 60.0,
                                            height: 60.0,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/default_profile.png',
                                            width: 60.0,
                                            height: 60.0,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Text(
                                      description,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Text(
                                    schoolName,
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
                                    color: Color(0xFFA0826A),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    region,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12.0),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Icon(
                                    willProvideAccommodation
                                        ? Icons.check_circle_outline
                                        : Icons.cancel_outlined,
                                    color: const Color(0xFFA0826A),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    willProvideAccommodation
                                        ? 'Accommodation provided'
                                        : 'No accommodation',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    color: Color(0xFFA0826A),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text('$numberOfWeeks Week(s)',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: () =>
                                          showSchoolDetails(context, schoolUID),
                                      child: const Text('View school details')),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFA0826A),
                                    ),
                                    onPressed: () => showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => ApplicationSheet(
                                        listingData: listingData,
                                        listingID:
                                            listingID, // Pass document ID
                                        volunteerUID:
                                            user!.uid, // Use the user's UID
                                        schoolUID: schoolUID, // Pass schoolUID
                                      ),
                                    ),
                                    child: const Text('Make application'),
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
            );
          }

          return Container(
            padding: const EdgeInsets.all(30.0),
            child: const Text(
              'Sorry!, No ongoing volunteering opportunities available for application.',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  void showSchoolDetails(BuildContext context, String schoolUID) async {
    try {
      // Fetch school details from Firestore
      DocumentSnapshot schoolSnapshot = await FirebaseFirestore.instance
          .collection('schools')
          .doc(schoolUID)
          .get();

      if (schoolSnapshot.exists) {
        final schoolData = schoolSnapshot.data() as Map<String, dynamic>;

        // Display the school details in a pop-up dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(schoolData['schoolName'] ?? 'School Details'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'Registration Number: ${schoolData['registrationNumber'] ?? ''}'),
                    Text('Phone Number: ${schoolData['phoneNumber'] ?? ''}'),
                    Text('Email: ${schoolData['email'] ?? ''}'),
                    Text('Region: ${schoolData['region'] ?? ''}'),
                    Text('District: ${schoolData['district'] ?? ''}'),
                    Text('Ward: ${schoolData['ward'] ?? ''}'),
                    Text(
                        'Gender Composition: ${schoolData['genderComposition'] ?? ''}'),
                    Text('Boarding: ${schoolData['isBoarding'] ?? false}'),
                    Text('Private: ${schoolData['isPrivate'] ?? false}'),
                    Text('Religious: ${schoolData['isReligious'] ?? false}'),
                    Text(
                        'Number of Students: ${schoolData['numberOfStudents'] ?? ''}'),
                    Text('Religion: ${schoolData['religion'] ?? ''}'),
                    Text('School Type: ${schoolData['schoolType'] ?? ''}'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Handle the case where the school does not exist
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('School details not found.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to fetch school details: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
