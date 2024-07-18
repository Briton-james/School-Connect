import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SchoolSearchContents extends StatefulWidget {
  const SchoolSearchContents({super.key});

  @override
  _SchoolSearchContentsState createState() => _SchoolSearchContentsState();
}

class _SchoolSearchContentsState extends State<SchoolSearchContents> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Future<QuerySnapshot>? _searchResults;
  String? schoolName;
  String? schoolLocation;
  String? schoolId;
  String status = 'pending';

  @override
  void initState() {
    super.initState();
    _fetchSchoolDetails();
  }

  Future<void> _fetchSchoolDetails() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot schoolDoc = await FirebaseFirestore.instance
          .collection('schools')
          .doc(user.uid)
          .get();

      if (schoolDoc.exists) {
        setState(() {
          schoolId = schoolDoc.id;
          schoolName = schoolDoc['schoolName'];
          schoolLocation = schoolDoc['region'];
        });
      }
    }
  }

  void _searchVolunteers() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
      if (_searchQuery.isNotEmpty) {
        _searchResults = FirebaseFirestore.instance
            .collection('users')
            .where('subjects', arrayContains: _searchQuery)
            .get();
      } else {
        _searchResults = null;
      }
    });
  }

  void _requestVolunteer(Map<String, dynamic> volunteerData) async {
    if (volunteerData['availabilityStatus'] != 'available') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This volunteer is currently assisting another school'),
        ),
      );
      return; // Exit the function if the volunteer is not available
    }

    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController weeksController = TextEditingController();
        List<dynamic> subjects = volunteerData['subjects'] ?? [];
        List<String> selectedSubjects = [];
        bool financialAssistance = false;
        bool accommodationAvailable = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Request ${volunteerData['firstname']}'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Select subjects:'),
                    ...subjects.map((subject) {
                      return CheckboxListTile(
                        title: Text(subject),
                        value: selectedSubjects.contains(subject),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedSubjects.add(subject);
                            } else {
                              selectedSubjects.remove(subject);
                            }
                          });
                        },
                      );
                    }).toList(),
                    TextField(
                      controller: weeksController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Number of weeks for volunteering',
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text(
                          'School will provide financial assistance'),
                      value: financialAssistance,
                      onChanged: (bool? value) {
                        setState(() {
                          financialAssistance = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('School will provide accommodation'),
                      value: accommodationAvailable,
                      onChanged: (bool? value) {
                        setState(() {
                          accommodationAvailable = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (schoolName == null ||
                        schoolLocation == null ||
                        schoolId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error retrieving school details'),
                        ),
                      );
                      return;
                    }

                    FirebaseFirestore.instance.collection('requests').add({
                      'volunteerId': volunteerData['uid'],
                      'schoolId': schoolId,
                      'schoolName': schoolName,
                      'schoolLocation': schoolLocation,
                      'subjects': selectedSubjects,
                      'financialAssistance': financialAssistance,
                      'accommodation': accommodationAvailable,
                      'NumberOfWeeks': weeksController.text,
                      'status': status,
                      'message':
                          'Hello ${volunteerData['firstname']},  $schoolName is requesting your assistance for subject(s): ${selectedSubjects.join(', ')}.',
                    }).then((requestDoc) {
                      // Create a notification after the request is successfully created
                      FirebaseFirestore.instance
                          .collection('notifications')
                          .add({
                        'schoolId': schoolId,
                        'createdAt': FieldValue.serverTimestamp(),
                        'message':
                            'Hello ${volunteerData['firstname']},  $schoolName is requesting your assistance for subject(s): ${selectedSubjects.join(', ')}.',
                        'volunteerId': volunteerData['uid'],
                        'type': 'request',
                        'read': false,
                        'requestId': requestDoc.id,
                      });
                    });

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Request sent successfully'),
                      ),
                    );
                  },
                  child: const Text('Send Request'),
                ),
              ],
            );
          },
        );
      },
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
                hintText: 'Search subjects..',
                hintFadeDuration: const Duration(seconds: 3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) => _searchVolunteers(),
            ),
            const SizedBox(height: 20),
            _searchResults == null
                ? Container()
                : FutureBuilder<QuerySnapshot>(
                    future: _searchResults,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text(
                          'No volunteers found for "$_searchQuery"',
                          style: const TextStyle(color: Colors.white),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final document = snapshot.data!.docs[index];
                            final volunteerData =
                                document.data() as Map<String, dynamic>;

                            return Card(
                              color: const Color(0xff34515e),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            volunteerData['photoURL'] ?? '',
                                          ),
                                          radius: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${volunteerData['firstname'] ?? 'No Name'} ${volunteerData['surname'] ?? ''}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              volunteerData['email'] ??
                                                  'No Email',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Age: ${volunteerData['age'] ?? 'N/A'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Gender: ${volunteerData['gender'] ?? 'N/A'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Marital Status: ${volunteerData['maritalStatus'] ?? 'N/A'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Education Level: ${volunteerData['educationLevel'] ?? 'N/A'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Employment Status: ${volunteerData['employmentStatus'] ?? 'N/A'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Availability Status: ${volunteerData['availabilityStatus'] ?? 'N/A'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Phone: ${volunteerData['phoneNumber'] ?? 'N/A'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Region: ${volunteerData['region'] ?? 'N/A'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'District: ${volunteerData['district'] ?? 'N/A'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Street: ${volunteerData['street'] ?? 'N/A'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Ward: ${volunteerData['ward'] ?? 'N/A'}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Subjects: ${(volunteerData['subjects'] as List<dynamic>).join(', ')}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            _requestVolunteer(volunteerData),
                                        child: const Text('Request'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
