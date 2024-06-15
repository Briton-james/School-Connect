import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_connect/components/widgets/select_subject.dart';

class ApplicationSheet extends StatefulWidget {
  final Map<String, dynamic> listingData; // Pass listing data to constructor
  final String volunteerUID; // Volunteer UID (assuming retrieved from auth)
  final String schoolUID; // Pass school UID from HomeContents
  final String listingID; // Pass listing ID from HomeContents

  const ApplicationSheet({
    Key? key,
    required this.listingData,
    required this.volunteerUID,
    required this.schoolUID,
    required this.listingID,
  }) : super(key: key);

  @override
  _ApplicationSheetState createState() => _ApplicationSheetState();
}

class _ApplicationSheetState extends State<ApplicationSheet> {
  List<Subject> _selectedSubjects = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.70, //Bottom sheet to cover 90% of screen size
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        color: Color(0xff0E424C),
      ),
      child: Card(
        color: const Color(0xff0E424C),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Container(
                    width: 50.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              // Listing information section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.school,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      widget.listingData['schoolName']?.toString() ?? '',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.description,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      widget.listingData['description']?.toString() ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      '${widget.listingData['numberOfWeeks']?.toString() ?? ''} week(s)',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Row(
                children: [
                  Text(
                    "Subjects you can teach:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              SubjectSelection(
                onSelectedSubjectsChanged: (selectedSubjects) {
                  setState(() {
                    _selectedSubjects = selectedSubjects;
                  });
                },
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffA0826A),
                ),
                onPressed: () async {
                  setState(() {
                    _isLoading =
                        true; // Set loading flag to true when submitting application
                  });

                  // Create application data
                  final applicationData = {
                    'volunteerUID': widget.volunteerUID,
                    'schoolUID': widget.schoolUID,
                    'listingUID': widget.listingID,
                    'status': 'pending',
                    'timestamp': FieldValue.serverTimestamp(),
                    'subjects': _selectedSubjects
                        .map((subject) => subject.name)
                        .toList(),
                  };

                  // Add application to Firestore
                  try {
                    await FirebaseFirestore.instance
                        .collection('applications')
                        .add(applicationData);

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Application submitted successfully!'),
                      ),
                    );

                    // Close the bottom sheet
                    Navigator.pop(context);
                  } catch (e) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                            'Failed to submit application. Please try again.'),
                      ),
                    );
                  } finally {
                    setState(() {
                      _isLoading =
                          false; // Set loading flag to false after submitting application
                    });
                  }
                },
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      )
                    : const Text('Submit Application'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
