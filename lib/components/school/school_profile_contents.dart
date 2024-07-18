import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:school_connect/screens/sign_in_screen.dart';

class SchoolProfileContents extends StatefulWidget {
  const SchoolProfileContents({Key? key}) : super(key: key);

  @override
  _SchoolProfileContentsState createState() => _SchoolProfileContentsState();
}

class _SchoolProfileContentsState extends State<SchoolProfileContents> {
  // Sample profile data (initially used for display before fetching from DB)
  String _schoolName = '';
  String _registrationNumber = '';
  String _region = '';
  String _district = '';
  String _ward = '';
  String _email = '';
  String _phoneNumber = '';
  String _profileImageUrl = '';

  // Editing status
  bool _isEditing = false;

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Form controllers (initially empty)
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSchoolData();
  }

  Future<void> _fetchSchoolData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String uid = user.uid;
        final docRef =
            FirebaseFirestore.instance.collection('schools').doc(uid);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _schoolName = data['schoolName'] ?? '';
            _registrationNumber = data['registrationNumber'] ?? '';
            _region = data['region'] ?? '';
            _district = data['district'] ?? '';
            _ward = data['ward'] ?? '';
            _email = data['email'] ?? '';
            _phoneNumber = data['phoneNumber'] ?? '';
            _profileImageUrl = data['profileImageUrl'] ?? '';
          });
        } else {
          // Handle case where school document doesn't exist (optional)
        }
      }
    } catch (e) {
      print("Error fetching school data: $e");
    }
  }

  Future<void> updateSchoolDetails({
    required String schoolName,
    required String registrationNumber,
    required String region,
    required String district,
    required String ward,
    required String email,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String uid = user.uid;
        final docRef =
            FirebaseFirestore.instance.collection('schools').doc(uid);
        await docRef.update({
          'schoolName': schoolName,
          'registrationNumber': registrationNumber,
          'region': region,
          'district': district,
          'ward': ward,
          'email': email,
          'phoneNumber': phoneNumber,
          if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        });
      }
    } catch (e) {
      //exceptions
    }
  }

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/${file.name}');
      await storageRef.putFile(File(file.path!));
      final downloadUrl = await storageRef.getDownloadURL();
      setState(() {
        _profileImageUrl = downloadUrl;
      });
      updateSchoolDetails(
        schoolName: _schoolName,
        registrationNumber: _registrationNumber,
        region: _region,
        district: _district,
        ward: _ward,
        email: _email,
        phoneNumber: _phoneNumber,
        profileImageUrl: downloadUrl,
      );
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
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: _profileImageUrl.isNotEmpty
                        ? NetworkImage(_profileImageUrl)
                        : const AssetImage('assets/images/default_profile.png')
                            as ImageProvider,
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
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
        _buildProfileField('School Name', _schoolName),
        _buildProfileField('Registration Number', _registrationNumber),
        _buildProfileField('Phone number', _phoneNumber),
        _buildProfileField('Email', _email),
        _buildProfileField('Region', _region),
        _buildProfileField('District', _district),
        _buildProfileField('Ward', _ward),
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
                  color: Colors.black),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
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
          TextFormField(
            controller: _schoolNameController..text = _schoolName,
            decoration: const InputDecoration(labelText: 'School Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter school name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _registrationNumberController
              ..text = _registrationNumber,
            decoration: const InputDecoration(labelText: 'Registration Number'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter registration number';
              }
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _emailController..text = _email,
            decoration: const InputDecoration(labelText: 'Email'),
            readOnly: true,
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _phoneNumberController..text = _phoneNumber,
            decoration: const InputDecoration(labelText: 'Phone'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone';
              }
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _regionController..text = _region,
            decoration: const InputDecoration(labelText: 'Region'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your region';
              }
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _districtController..text = _district,
            decoration: const InputDecoration(labelText: 'District'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your district';
              }
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: _wardController..text = _ward,
            decoration: const InputDecoration(labelText: 'Ward'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your ward';
              }
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
                    updateSchoolDetails(
                      schoolName: _schoolNameController.text.trim(),
                      registrationNumber:
                          _registrationNumberController.text.trim(),
                      region: _regionController.text.trim(),
                      district: _districtController.text.trim(),
                      ward: _wardController.text.trim(),
                      email: _emailController.text.trim(),
                      phoneNumber: _phoneNumberController.text.trim(),
                    );
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
