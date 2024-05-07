import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_connect/screens/sign_in_screen.dart';

class ProfileContents extends StatefulWidget {
  const ProfileContents({Key? key}) : super(key: key);

  @override
  _ProfileContentsState createState() => _ProfileContentsState();
}

class _ProfileContentsState extends State<ProfileContents> {
  // Sample profile data (initially used for display before fetching from DB)
  String _firstname = '';
  String _surname = '';
  String _email = '';
  String _phoneNumber = '';

  // Editing status
  bool _isEditing = false;

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Form controllers (initially empty)
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // Fetch user data upon initialization
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String uid = user.uid;
        print("Current user UID: $uid"); // For debugging

        final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _firstname = data['firstname'] ?? '';
            _surname = data['surname'] ?? '';
            _email = data['email'] ?? '';
            _phoneNumber = data['phone'] ?? '';
          });
        } else {
          print("User document not found");
          // Handle case where user document doesn't exist (optional)
          // You might want to navigate to a signup page or display a message
        }
      } else {
        print("Current user is null");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> updateUserDetails({
    required String firstname,
    required String surname,
    required String phone,
  }) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String uid = user.uid;

        final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
        await docRef.update({
          'first name': firstname,
          'surname': surname,
          'phone': phone,
        });

        print("User profile updated successfully!");
        // Update state variables with new data (optional)
      } else {
        print("No user signed in");
      }
    } catch (e) {
      print("Error updating user data: $e");
      // Show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profile picture (replace with your implementation)

                const CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage('https://placehold.it/100x100'),
                  // Placeholder image
                ),
                IconButton(
                  onPressed: () async {
                    // Logout functionality

                    await FirebaseAuth.instance.signOut();
                    print("User signed out successfully!");
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            _isEditing ? _buildEditProfileForm() : _buildProfileDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileField('Firstname', _firstname),
        _buildProfileField('Surname', _surname),
        _buildProfileField('Email', _email),
        _buildProfileField('Phone Number', _phoneNumber),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              icon: const Icon(Icons.edit),
              color: const Color(0xffA0826A),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _isEditing
              ? TextFormField(
                  initialValue: value, // Set initial value from fetched data
                  decoration: InputDecoration(
                    labelText: label,
                    border:
                        const OutlineInputBorder(), // Add border for editing mode
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
        ),
      ],
    );
  }

  Widget _buildEditProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _firstnameController..text = _firstname,
            decoration: const InputDecoration(labelText: 'Firstname'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your firstname';
              }
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _surnameController..text = _surname,
            decoration: const InputDecoration(labelText: 'Surname'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your surname';
              }
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _emailController..text = _email,
            decoration: const InputDecoration(labelText: 'Email'),
            readOnly: true, // Email should not be editable
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _phoneNumberController..text = _phoneNumber,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            validator: (value) {
              // Add logic to validate phone number format (optional)
              updateUserDetails(
                  firstname: _firstnameController.text.trim(),
                  surname: _surnameController.text.trim(),
                  phone: _phoneNumberController.text.trim());
              return null;
            },
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() => _isEditing = false),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Update user profile in Firestore (implement update logic)
                    print('Profile updated');
                    setState(() => _isEditing = false);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
