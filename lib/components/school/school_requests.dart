import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SchoolRequests extends StatefulWidget {
  const SchoolRequests({super.key});

  @override
  _SchoolRequestsState createState() => _SchoolRequestsState();
}

class _SchoolRequestsState extends State<SchoolRequests> {
  String? schoolId;
  String _selectedStatus = 'pending';

  @override
  void initState() {
    super.initState();
    _fetchSchoolId();
  }

  Future<void> _fetchSchoolId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        schoolId = user.uid;
      });
    }
  }

  Future<QuerySnapshot> _fetchRequests() {
    Query query = FirebaseFirestore.instance
        .collection('requests')
        .where('schoolId', isEqualTo: schoolId);

    if (_selectedStatus != 'All') {
      query = query.where('status', isEqualTo: _selectedStatus);
    }

    return query.get();
  }

  Future<DocumentSnapshot> _fetchVolunteerDetails(String volunteerId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(volunteerId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E424C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E424C),
        title: const Text(
          'Requested Volunteers',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          DropdownButton<String>(
            value: _selectedStatus,
            dropdownColor: const Color(0xFF0E424C),
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatus = newValue!;
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
        ],
      ),
      body: schoolId == null
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
                    final volunteerId = requestData['volunteerId'];

                    return FutureBuilder<DocumentSnapshot>(
                      future: _fetchVolunteerDetails(volunteerId),
                      builder: (context, volunteerSnapshot) {
                        if (volunteerSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: LoadingAnimationWidget.beat(
                                color: const Color(0xffA0826A), size: 20),
                          );
                        }
                        if (volunteerSnapshot.hasError) {
                          return ListTile(
                            title: Text('Error: ${volunteerSnapshot.error}'),
                          );
                        }
                        if (!volunteerSnapshot.hasData ||
                            !volunteerSnapshot.data!.exists) {
                          return const ListTile(
                            title: Text('Volunteer not found.'),
                          );
                        }

                        final volunteerData = volunteerSnapshot.data!.data()
                            as Map<String, dynamic>;

                        return Card(
                          color: const Color(0xFF0E424C),
                          child: ListTile(
                            title: Text(
                              '${volunteerData['firstname']} ${volunteerData['surname']}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Subjects: ${requestData['subjects'].join(', ')}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Duration: ${requestData['NumberOfWeeks']} weeks',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Status: ${requestData['status'] ?? 'Pending'}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                _showVolunteerDetailsDialog(
                                    context, volunteerData);
                              },
                              child: const Text('Volunteer Details'),
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

  void _showVolunteerDetailsDialog(
      BuildContext context, Map<String, dynamic> volunteerData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text('${volunteerData['firstname']} ${volunteerData['surname']}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                volunteerData['photoURL'] != null
                    ? Image.network(volunteerData['photoURL'])
                    : const SizedBox.shrink(),
                Text('Age: ${volunteerData['age'] ?? 'N/A'}'),
                Text('Gender: ${volunteerData['gender'] ?? 'N/A'}'),
                Text(
                    'Marital Status: ${volunteerData['maritalStatus'] ?? 'N/A'}'),
                Text(
                    'Education Level: ${volunteerData['educationLevel'] ?? 'N/A'}'),
                Text(
                    'Employment Status: ${volunteerData['employmentStatus'] ?? 'N/A'}'),
                Text('Phone: ${volunteerData['phoneNumber'] ?? 'N/A'}'),
                Text('Region: ${volunteerData['region'] ?? 'N/A'}'),
                Text('District: ${volunteerData['district'] ?? 'N/A'}'),
                Text('Street: ${volunteerData['street'] ?? 'N/A'}'),
                Text('Ward: ${volunteerData['ward'] ?? 'N/A'}'),
                Text('Subjects: ${volunteerData['subjects'].join(', ')}'),
                Text('Email: ${volunteerData['email'] ?? 'N/A'}'),
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
