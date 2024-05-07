import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_connect/components/widgets/week_selection.dart';

class ListingSheet extends StatefulWidget {
  const ListingSheet({Key? key}) : super(key: key);

  @override
  State<ListingSheet> createState() => _ListingSheetState();
}

class _ListingSheetState extends State<ListingSheet> {
  int _groupValue = 0;
  TextEditingController _descriptionController = TextEditingController();
  int _numberOfWeeks = 1;

  // Get screen height
  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenHeight(context) *
          0.70, // Bottom sheet to cover 70% of screen size
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
                'Listing information',
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
                decoration: InputDecoration(
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
              const Text(
                'Will your school provide accommodation?',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              RadioListTile<int>(
                value: 0, // Value for "No"
                groupValue: _groupValue,
                onChanged: (newValue) =>
                    setState(() => _groupValue = newValue!),
                title: const Text('No', style: TextStyle(color: Colors.white)),
              ),
              RadioListTile<int>(
                value: 1, // Value for "Yes"
                groupValue: _groupValue,
                onChanged: (newValue) =>
                    setState(() => _groupValue = newValue!),
                title: const Text('Yes', style: TextStyle(color: Colors.white)),
              ),
              const Spacer(),
              NumberOfWeeksSelector(
                onChanged: (value) {
                  // Assuming NumberOfWeeksSelector has an onChanged callback
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
                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevent user from dismissing dialog
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  // Get the current user
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    // Construct the data to be stored in Firestore
                    Map<String, dynamic> listingData = {
                      'description': _descriptionController.text,
                      'willProvideAccommodation':
                          _groupValue == 1, // Convert to boolean
                      'numberOfWeeks': _numberOfWeeks,
                      'uid': user.uid,
                      'timestamp': Timestamp.now(),
                    };

                    try {
                      // Add the listing data to Firestore
                      await FirebaseFirestore.instance
                          .collection('listings')
                          .add(listingData);

                      // Show success toast message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Listing posted successfully!'),
                        ),
                      );
                    } catch (e) {
                      // Show error toast message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Error posting listing: $e'),
                        ),
                      );
                    } finally {
                      // Close the loading indicator dialog and bottom sheet
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Close bottom sheet
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
