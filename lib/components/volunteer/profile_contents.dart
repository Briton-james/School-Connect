import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_connect/screens/sign_in_screen.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ProfileContents extends StatefulWidget {
  const ProfileContents({Key? key}) : super(key: key);

  @override
  _ProfileContentsState createState() => _ProfileContentsState();
}

class _ProfileContentsState extends State<ProfileContents> {
  String _firstname = '';
  String _surname = '';
  String _email = '';
  String _phoneNumber = '';
  String _age = '';
  String _district = '';
  String _educationLevel = '';
  String _employmentStatus = '';
  String _gender = '';
  String _maritalStatus = '';
  String _region = '';
  String _ward = '';
  String? _photoURL;
  String? _certificateURL;
  List<dynamic> _subjects = [];

  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _educationLevelController =
      TextEditingController();
  final TextEditingController _employmentStatusController =
      TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _subjectsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String uid = user.uid;
        final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _firstname = data['firstname'] ?? '';
            _surname = data['surname'] ?? '';
            _email = data['email'] ?? '';
            _phoneNumber = data['phoneNumber'] ?? '';
            _age = data['age'] ?? '';
            _district = data['district'] ?? '';
            _educationLevel = data['educationLevel'] ?? '';
            _employmentStatus = data['employmentStatus'] ?? '';
            _gender = data['gender'] ?? '';
            _maritalStatus = data['maritalStatus'] ?? '';
            _region = data['region'] ?? '';
            _ward = data['ward'] ?? '';
            _photoURL = data['photoURL'];
            _certificateURL = data['certificateURL'];
            _subjects = data['subjects'] ?? [];
          });
        } else {
          print("User document not found");
        }
      } else {
        print("Current user is null");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _updateUserDetails() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String uid = user.uid;

        final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
        await docRef.update({
          'firstname': _firstnameController.text.trim(),
          'surname': _surnameController.text.trim(),
          'phoneNumber': _phoneNumberController.text.trim(),
          'age': _ageController.text.trim(),
          'district': _districtController.text.trim(),
          'educationLevel': _educationLevelController.text.trim(),
          'employmentStatus': _employmentStatusController.text.trim(),
          'gender': _genderController.text.trim(),
          'maritalStatus': _maritalStatusController.text.trim(),
          'region': _regionController.text.trim(),
          'ward': _wardController.text.trim(),
          'subjects': _subjectsController.text
              .trim()
              .split(',')
              .map((e) => e.trim())
              .toList(),
        });

        print("User profile updated successfully!");
        // Update state variables with new data (optional)
      } else {
        print("No user signed in");
      }
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String uid = user.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('$uid.jpg');
        await ref.putFile(file);
        final photoURL = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'photoURL': photoURL,
        });

        setState(() {
          _photoURL = photoURL;
        });

        print("Profile picture updated successfully!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E424C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E424C),
        title: const Text(
          "Your profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundImage: _photoURL != null
                          ? NetworkImage(_photoURL!)
                          : const AssetImage(
                                  'assets/images/default_profile.png')
                              as ImageProvider,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(
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
        _buildProfileField('Age', _age),
        _buildProfileField('District', _district),
        _buildProfileField('Education Level', _educationLevel),
        _buildProfileField('Employment Status', _employmentStatus),
        _buildProfileField('Gender', _gender),
        _buildProfileField('Marital Status', _maritalStatus),
        _buildProfileField('Region', _region),
        _buildProfileField('Ward', _ward),
        _buildProfileField('Subjects', _subjects.join(', ')),
        const SizedBox(height: 20),
        if (_certificateURL != null)
          GestureDetector(
            onTap: () => _launchURL(_certificateURL!),
            child: const Text(
              'View Certificate',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEditableField('Firstname', _firstnameController, _firstname),
          _buildEditableField('Surname', _surnameController, _surname),
          _buildEditableField(
              'Phone Number', _phoneNumberController, _phoneNumber),
          _buildEditableField('Age', _ageController, _age),
          _buildEditableField('District', _districtController, _district),
          _buildEditableField(
              'Education Level', _educationLevelController, _educationLevel),
          _buildEditableField('Employment Status', _employmentStatusController,
              _employmentStatus),
          _buildEditableField('Gender', _genderController, _gender),
          _buildEditableField(
              'Marital Status', _maritalStatusController, _maritalStatus),
          _buildEditableField('Region', _regionController, _region),
          _buildEditableField('Ward', _wardController, _ward),
          _buildEditableField(
              'Subjects', _subjectsController, _subjects.join(', ')),
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
                    _updateUserDetails();
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

  Widget _buildEditableField(
      String label, TextEditingController controller, String initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller..text = initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await launcher.canLaunchUrl(url as Uri)) {
      await launcher.launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
