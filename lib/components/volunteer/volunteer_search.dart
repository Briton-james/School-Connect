import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'application_sheet.dart';

class VolunteerSearchContents extends StatefulWidget {
  const VolunteerSearchContents({super.key});

  @override
  State<VolunteerSearchContents> createState() =>
      _VolunteerSearchContentsState();
}

class _VolunteerSearchContentsState extends State<VolunteerSearchContents> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];

  void _search() async {
    String searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore
          .collection('listings')
          .where('schoolName', isGreaterThanOrEqualTo: searchQuery)
          .where('schoolName', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .get();

      QuerySnapshot locationSnapshot = await firestore
          .collection('listings')
          .where('location', isGreaterThanOrEqualTo: searchQuery)
          .where('location', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .get();

      setState(() {
        searchResults = [...querySnapshot.docs, ...locationSnapshot.docs]
            .toSet()
            .toList(); // Remove duplicates
      });
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  Future<Map<String, dynamic>?> fetchSchoolDetails(String uid) async {
    try {
      DocumentSnapshot schoolSnapshot =
          await FirebaseFirestore.instance.collection('schools').doc(uid).get();
      if (schoolSnapshot.exists) {
        return schoolSnapshot.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print("Error fetching school details: $e");
    }
    return null;
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
                    Text('District: ${schoolData['district'] ?? ''}'),
                    Text('Email: ${schoolData['email'] ?? ''}'),
                    Text(
                        'Gender Composition: ${schoolData['genderComposition'] ?? ''}'),
                    Text('Boarding: ${schoolData['isBoarding'] ?? false}'),
                    Text('Private: ${schoolData['isPrivate'] ?? false}'),
                    Text('Religious: ${schoolData['isReligious'] ?? false}'),
                    Text(
                        'Number of Students: ${schoolData['numberOfStudents'] ?? ''}'),
                    Text('Phone Number: ${schoolData['phoneNumber'] ?? ''}'),
                    Text('Region: ${schoolData['region'] ?? ''}'),
                    Text(
                        'Registration Number: ${schoolData['registrationNumber'] ?? ''}'),
                    Text('Religion: ${schoolData['religion'] ?? ''}'),
                    Text('School Type: ${schoolData['schoolType'] ?? ''}'),
                    Text('Ward: ${schoolData['ward'] ?? ''}'),
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

  Widget buildCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    String description = data['description'] ?? '';
    String schoolName = data['schoolName'] ?? '';
    String region = data['region'] ?? '';
    bool willProvideAccommodation = data['willProvideAccommodation'] ?? false;
    int numberOfWeeks = int.tryParse(data['numberOfWeeks'].toString()) ?? 0;
    String schoolUID = data['uid'] ?? '';
    String profileImageUrl =
        data['profileImageUrl'] ?? 'assets/images/default_profile.png';

    return Card(
      color: const Color(0xFF0E424C),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(8.0),
                //   child: profileImageUrl.isNotEmpty
                //       ? Image.network(
                //           profileImageUrl,
                //           width: 50.0,
                //           height: 50.0,
                //           fit: BoxFit.cover,
                //         )
                //       : Image.asset(
                //           'assets/images/default_profile.png',
                //           width: 50.0,
                //           height: 50.0,
                //           fit: BoxFit.cover,
                //         ),
                // ),
                // const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    description,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
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
                  style: const TextStyle(color: Colors.white, fontSize: 12.0),
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
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => showSchoolDetails(context, schoolUID),
                  child: const Text('View school details'),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA0826A),
                  ),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => ApplicationSheet(
                      listingData: data,
                      listingID: doc.id,
                      volunteerUID: FirebaseAuth.instance.currentUser!.uid,
                      schoolUID: schoolUID,
                    ),
                  ),
                  child: const Text('Make application'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E424C),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search schools...',
                hintFadeDuration: const Duration(seconds: 3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                _search();
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = searchResults[index];
                  return buildCard(doc);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
