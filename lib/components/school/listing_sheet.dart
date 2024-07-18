import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_connect/components/widgets/week_selection.dart';

class ListingSheet extends StatefulWidget {
  const ListingSheet({Key? key}) : super(key: key);

  @override
  State<ListingSheet> createState() => _ListingSheetState();
}

class _ListingSheetState extends State<ListingSheet> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  int _numberOfWeeks = 1;
  bool _provideAccommodation = false;
  bool _provideFinancialAssistance = false;
  Timestamp? _deadlineTimestamp;

  // Get screen height
  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  Future<void> _selectDeadline(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _deadlineTimestamp = Timestamp.fromDate(selectedDateTime);
          _deadlineController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenHeight(context) * 0.70,
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
              const SizedBox(height: 18.0),
              const Text(
                'New Listing Information',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Text(
                'Description',
                textAlign: TextAlign.left,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              TextField(
                controller: _descriptionController,
                maxLength: 100,
                minLines: 4,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText:
                      'Eg. In need of...teachers for...subjects, ... each subject',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 10.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Spacer(),
              CheckboxListTile(
                title: const Text(
                  'Will your school provide accommodation?',
                  style: TextStyle(color: Colors.white),
                ),
                value: _provideAccommodation,
                onChanged: (newValue) {
                  setState(() {
                    _provideAccommodation = newValue!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text(
                  'Will your school provide financial assistance?',
                  style: TextStyle(color: Colors.white),
                ),
                value: _provideFinancialAssistance,
                onChanged: (newValue) {
                  setState(() {
                    _provideFinancialAssistance = newValue!;
                  });
                },
              ),
              const Spacer(),
              TextField(
                controller: _deadlineController,
                readOnly: true,
                onTap: () => _selectDeadline(context),
                decoration: const InputDecoration(
                  labelText: 'Application Deadline',
                  hintText: 'Select date and time',
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              NumberOfWeeksSelector(
                onChanged: (value) {
                  setState(() {
                    _numberOfWeeks = value;
                  });
                },
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffA0826A),
                ),
                onPressed: () async {
                  if (_descriptionController.text.isEmpty ||
                      _deadlineTimestamp == null) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please fill all fields.'),
                      ),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    DocumentSnapshot schoolSnapshot = await FirebaseFirestore
                        .instance
                        .collection('schools')
                        .doc(user.uid)
                        .get();

                    String region = schoolSnapshot.get('region');
                    String district = schoolSnapshot.get('district');
                    String ward = schoolSnapshot.get('ward');
                    String street = schoolSnapshot.get('street');
                    String schoolName = schoolSnapshot.get('schoolName');

                    String location = '$region, $district, $ward, $street';

                    Map<String, dynamic> listingData = {
                      'description': _descriptionController.text,
                      'willProvideAccommodation': _provideAccommodation,
                      'willProvideFinancialAssistance':
                          _provideFinancialAssistance,
                      'deadline': _deadlineTimestamp,
                      'numberOfWeeks': _numberOfWeeks,
                      'uid': user.uid,
                      'region': region,
                      'district': district,
                      'ward': ward,
                      'street': street,
                      'location': location,
                      'schoolName': schoolName,
                      'status': 'ongoing',
                      'timestamp': Timestamp.now(),
                    };

                    try {
                      await FirebaseFirestore.instance
                          .collection('listings')
                          .add(listingData);

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Listing posted successfully!'),
                        ),
                      );
                    } catch (e) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Error posting listing: $e'),
                        ),
                      );
                    } finally {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
