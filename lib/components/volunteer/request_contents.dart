import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class VolunteerRequests extends StatefulWidget {
  const VolunteerRequests({super.key});

  @override
  _VolunteerRequestsState createState() => _VolunteerRequestsState();
}

class _VolunteerRequestsState extends State<VolunteerRequests> {
  String? volunteerId;

  @override
  void initState() {
    super.initState();
    _fetchVolunteerId();
  }

  Future<void> _fetchVolunteerId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        volunteerId = user.uid;
      });
    }
  }

  Future<QuerySnapshot> _fetchRequests() {
    return FirebaseFirestore.instance
        .collection('requests')
        .where('volunteerId', isEqualTo: volunteerId)
        .get();
  }

  Future<DocumentSnapshot> _fetchSchoolDetails(String schoolId) {
    return FirebaseFirestore.instance.collection('schools').doc(schoolId).get();
  }

  Future<void> _updateRequestStatus(String requestId, String status) {
    return FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .update({'status': status});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E424C),
      appBar: AppBar(
        backgroundColor: const Color(0xff0E424C),
        title: const Text(
          'Volunteer Requests',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: volunteerId == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<QuerySnapshot>(
              future: _fetchRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No requests found.'));
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final requestData =
                        requests[index].data() as Map<String, dynamic>;
                    final requestId = requests[index].id;
                    final schoolId = requestData['schoolId'];

                    return FutureBuilder<DocumentSnapshot>(
                      future: _fetchSchoolDetails(schoolId),
                      builder: (context, schoolSnapshot) {
                        if (schoolSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: LoadingAnimationWidget.beat(
                                color: const Color(0xffA0826A), size: 10),
                          );
                        }
                        if (schoolSnapshot.hasError) {
                          return ListTile(
                            title: Text('Error: ${schoolSnapshot.error}'),
                          );
                        }
                        if (!schoolSnapshot.hasData ||
                            !schoolSnapshot.data!.exists) {
                          return const ListTile(
                            title: Text('School not found.'),
                          );
                        }

                        final schoolData =
                            schoolSnapshot.data!.data() as Map<String, dynamic>;

                        return Card(
                          color: const Color(0xff0E424C),
                          child: ListTile(
                            title: Text(
                              schoolData['schoolName'] ?? 'No Name',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location: ${requestData['location'] ?? 'N/A'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                    'Accommodation Available: ${requestData['accommodationAvailable'] ?? false ? 'Yes' : 'No'}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                    'Financial Assistance: ${requestData['financialAssistance'] ?? false ? 'Yes' : 'No'}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                    'Subjects: ${requestData['subjects'].join(', ')}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                    'Number of Weeks: ${requestData['numberOfWeeks']}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                Text(
                                    'Status: ${requestData['status'] ?? 'Pending'}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (String value) {
                                if (value == 'Accept') {
                                  _updateRequestStatus(requestId, 'Accepted')
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text('Request accepted.'),
                                      ),
                                    );
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            'Failed to accept request: $error'),
                                      ),
                                    );
                                  });
                                } else if (value == 'Reject') {
                                  _updateRequestStatus(requestId, 'Rejected')
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor:
                                            Colors.deepOrangeAccent,
                                        content: Text('Request rejected.'),
                                      ),
                                    );
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Failed to reject request: $error'),
                                      ),
                                    );
                                  });
                                } else if (value == 'View School Details') {
                                  _showSchoolDetailsDialog(context, schoolData);
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: 'Accept',
                                    child: Text('Accept'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Reject',
                                    child: Text('Reject'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'View School Details',
                                    child: Text('View School Details'),
                                  ),
                                ];
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  void _showSchoolDetailsDialog(
      BuildContext context, Map<String, dynamic> schoolData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(schoolData['schoolName'] ?? 'No Name'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${schoolData['email'] ?? 'N/A'}'),
                Text('Phone: ${schoolData['phoneNumber'] ?? 'N/A'}'),
                Text('Region: ${schoolData['region'] ?? 'N/A'}'),
                Text('District: ${schoolData['district'] ?? 'N/A'}'),
                Text('Street: ${schoolData['street'] ?? 'N/A'}'),
                Text('Ward: ${schoolData['ward'] ?? 'N/A'}'),
                Text(
                    'Registration Number: ${schoolData['registrationNumber'] ?? 'N/A'}'),
                Text('School Type: ${schoolData['schoolType'] ?? 'N/A'}'),
                Text(
                    'Number of Students: ${schoolData['numberOfStudents'] ?? 'N/A'}'),
                Text(
                    'Gender Composition: ${schoolData['genderComposition'] ?? 'N/A'}'),
                Text(
                    'Is Boarding: ${schoolData['isBoarding'] == true ? 'Yes' : 'No'}'),
                Text(
                    'Is Private: ${schoolData['isPrivate'] == true ? 'Yes' : 'No'}'),
                Text(
                    'Is Religious: ${schoolData['isReligious'] == true ? 'Yes' : 'No'}'),
                if (schoolData['isReligious'] == true)
                  Text('Religion: ${schoolData['religion'] ?? 'N/A'}'),
                if (schoolData['isReligious'] == true)
                  Text('Religion Type: ${schoolData['religionType'] ?? 'N/A'}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
