import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageApplicationsScreen extends StatefulWidget {
  const ManageApplicationsScreen({Key? key}) : super(key: key);

  @override
  _ManageApplicationsScreenState createState() =>
      _ManageApplicationsScreenState();
}

class _ManageApplicationsScreenState extends State<ManageApplicationsScreen> {
  String selectedStatus = 'pending'; // Default filter status

  @override
  Widget build(BuildContext context) {
    // Get the UID of the current logged-in user (school)
    final currentUserUID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0E424C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E424C),
        title: const Text(
          'Manage Applications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFF0E424C),
              value: selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
              items: <String>['pending', 'accepted', 'rejected', 'All']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getApplicationsStream(currentUserUID, selectedStatus),
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
                      final application = snapshot.data!.docs[index];
                      final applicationData =
                          application.data() as Map<String, dynamic>?;

                      if (applicationData == null) {
                        // Handle null data gracefully
                        return const ListTile(
                          title: Text('Error: Application data is null'),
                        );
                      }

                      final volunteerUID =
                          applicationData['volunteerUID'] as String;

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(volunteerUID)
                            .get(),
                        builder: (context, volunteerSnapshot) {
                          if (volunteerSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ListTile(
                              title: Text(
                                'Loading Volunteer Details...',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }

                          if (volunteerSnapshot.hasError) {
                            return ListTile(
                              title: Text('Error: ${volunteerSnapshot.error}'),
                            );
                          }

                          if (!volunteerSnapshot.hasData) {
                            // Handle missing volunteer data gracefully
                            return const ListTile(
                              title: Text('Error: Volunteer data not found'),
                            );
                          }

                          final volunteerData = volunteerSnapshot.data!.data()
                              as Map<String, dynamic>?;

                          if (volunteerData == null) {
                            // Handle null volunteer data gracefully
                            return const ListTile(
                              title: Text('Error: Volunteer data is null'),
                            );
                          }

                          final volunteerName =
                              '${volunteerData['firstname'] ?? 'Unknown'} ${volunteerData['surname'] ?? 'Unknown'}';
                          final volunteerEmail =
                              volunteerData['email'] ?? 'Unknown';
                          final volunteerPhone =
                              volunteerData['phoneNumber'] ?? 'Unknown';

                          final subjects =
                              (applicationData['subjects'] as List<dynamic>?)
                                      ?.cast<String>() ??
                                  [];
                          final status =
                              applicationData['status'] as String? ?? '';
                          final timestamp =
                              (applicationData['timestamp'] as Timestamp?)
                                      ?.toDate() ??
                                  DateTime.now();

                          // Icon based on application status
                          late Color statusColor;
                          if (status == 'accepted') {
                            statusColor = Colors.green;
                          } else if (status == 'rejected') {
                            statusColor = Colors.red;
                          } else {
                            statusColor = Colors.amber;
                          }

                          return Card(
                            color: const Color(0xFF0E424C),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: ListTile(
                              title: Text(
                                'Volunteer: $volunteerName',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email: $volunteerEmail',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Phone: $volunteerPhone',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Subjects: ${subjects.join(', ')}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text('Status: $status',
                                      style: TextStyle(color: statusColor)),
                                  Text(
                                    'Applied on: $timestamp',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                itemBuilder: (context) => [
                                  const PopupMenuItem<String>(
                                    value: 'accept',
                                    child: ListTile(
                                      leading: Icon(Icons.check_circle,
                                          color: Colors.green),
                                      title: Text('Accept'),
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'reject',
                                    child: ListTile(
                                      leading:
                                          Icon(Icons.cancel, color: Colors.red),
                                      title: Text('Reject'),
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'accept') {
                                    _acceptApplication(application.id);
                                  } else if (value == 'reject') {
                                    _rejectApplication(application.id);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return const Center(child: Text('No applications available'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getApplicationsStream(
      String currentUserUID, String selectedStatus) {
    if (selectedStatus == 'All') {
      return FirebaseFirestore.instance
          .collection('applications')
          .where('schoolUID', isEqualTo: currentUserUID)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('applications')
          .where('schoolUID', isEqualTo: currentUserUID)
          .where('status', isEqualTo: selectedStatus)
          .snapshots();
    }
  }

  void _acceptApplication(String applicationId) {
    // Implement accept application functionality (update status in Firestore)
    FirebaseFirestore.instance
        .collection('applications')
        .doc(applicationId)
        .update({'status': 'accepted'});
  }

  void _rejectApplication(String applicationId) {
    // Implement reject application functionality (update status in Firestore)
    FirebaseFirestore.instance
        .collection('applications')
        .doc(applicationId)
        .update({'status': 'rejected'});
  }
}
