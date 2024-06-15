import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/location_services.dart';
import '../../screens/sign_in_screen.dart';

class VolunteerSignUpForm extends StatefulWidget {
  const VolunteerSignUpForm({Key? key}) : super(key: key);

  @override
  _VolunteerSignUpFormState createState() => _VolunteerSignUpFormState();
}

class _VolunteerSignUpFormState extends State<VolunteerSignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();

  String? _gender;
  String? _maritalStatus;
  String? _educationLevel;

  String? _selectedRegion;
  String? _selectedDistrict;
  final _streetController = TextEditingController();
  List<dynamic> _regions = [];
  List<dynamic> _districts = [];

  String? _selectedWard;
  List<String> _filteredDistricts = [];
  List<String> _filteredWards = [];

  List<String> _selectedSubjects = [];
  final List<String> _subjects = [
    "Mathematics",
    "Physics",
    "Chemistry",
    "Biology",
    "English",
    "History",
    "Geography",
    "Computer Science",
    // Add more subjects as needed
  ];

  bool _isLoading = false;
  File? _certificateFile;
  String? _uploadStatus;

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    final regions = await LocationService.loadRegions();
    final districts = await LocationService.loadDistricts();
    setState(() {
      _regions = regions;
      _districts = districts;
    });
  }

  void _filterDistricts(String? selectedRegion) {
    if (selectedRegion != null) {
      setState(() {
        _filteredDistricts = _regions
            .firstWhere(
                (region) => region['region'] == selectedRegion)['districts']
            .cast<String>();
        _selectedDistrict = null;
        _filteredWards = [];
        _selectedWard = null;
      });
    }
  }

  void _filterWards(String? selectedDistrict) {
    if (selectedDistrict != null) {
      setState(() {
        _filteredWards = _districts
            .where((district) =>
                district['properties']['District'] == selectedDistrict)
            .map((district) => district['properties']['Ward'])
            .cast<String>()
            .toList();
        _selectedWard = null;
      });
    }
  }

  bool _validateFields() {
    return _formKey.currentState!.validate();
  }

  Future<void> _signUp() async {
    if (_validateFields()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final String email = _emailController.text.trim();
        final String password = _passwordController.text.trim();

        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Get the current user UID
        final String uid = userCredential.user!.uid;

        // Upload certificate and get URL
        String? certificateURL = await _uploadCertificate();

        // Convert subjects to lowercase
        List<String> lowerCaseSubjects =
            _selectedSubjects.map((subject) => subject.toLowerCase()).toList();

        // Add user details to Firestore using UID
        await addUserDetails(
          uid: uid,
          firstname: _firstNameController.text.trim(),
          surname: _surnameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          userType: 'volunteer',
          age: _ageController.text.trim(),
          gender: _gender,
          maritalStatus: _maritalStatus,
          educationLevel: _educationLevel,
          region: _selectedRegion,
          district: _selectedDistrict,
          ward: _selectedWard,
          street: _streetController.text.trim(),
          certificateURL: certificateURL,
          subjects: lowerCaseSubjects,
        );

        print("Account created successfully!");
        Fluttertoast.showToast(
            msg: "Account created successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          Fluttertoast.showToast(
              msg: "The password is too weak!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          Fluttertoast.showToast(
              msg: "Email already in use!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          print(e.code);
          Fluttertoast.showToast(
              msg: "Sign up failed! ${e.toString()}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } catch (e) {
        print("Error signing up: $e");
        Fluttertoast.showToast(
            msg: "Sign up failed! ${e.toString()}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> addUserDetails(
      {required String uid,
      required String firstname,
      required String surname,
      required String email,
      required String phoneNumber,
      required String userType,
      required String age,
      required String? gender,
      required String? maritalStatus,
      required String? educationLevel,
      required String? region,
      required String? district,
      required String? ward,
      required String? street,
      required String? certificateURL,
      required List<String> subjects}) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await docRef.set({
        'uid': uid, // Store UID for reference
        'firstname': firstname,
        'surname': surname,
        'email': email,
        'phoneNumber': phoneNumber,
        'userType': userType,
        'age': age,
        'gender': gender,
        'maritalStatus': maritalStatus,
        'educationLevel': educationLevel,
        'region': region,
        'district': district,
        'ward': ward,
        'street': street,
        'certificateURL': certificateURL,
        'subjects': subjects,
      });

      print("User data added successfully!");
    } catch (e) {
      print("Error adding user data: $e");
    }
  }

  Future<void> _pickCertificate() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _certificateFile = File(result.files.single.path!);
      });
    }
  }

  Future<String?> _uploadCertificate() async {
    if (_certificateFile == null) return null;

    setState(() {
      _uploadStatus = "Uploading your certificate...";
    });

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = _certificateFile!.path.split('/').last;
      Reference ref = storage.ref().child('certificates/$fileName');
      UploadTask uploadTask = ref.putFile(_certificateFile!);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadStatus = "Certificate uploaded successfully.";
      });

      return downloadURL;
    } catch (e) {
      print("Error uploading certificate: $e");
      setState(() {
        _uploadStatus = "Certificate upload failed.";
      });
      return null;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E424C),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/book.png',
                  width: 100.0,
                  height: 100.0,
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                        text: 'School',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(children: [
                        TextSpan(
                          text: 'Connect',
                          style: TextStyle(
                            color: Color(0xffA0826A),
                          ),
                        ),
                      ])
                    ]),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Create account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    hint: 'Enter your first name'),
                const SizedBox(height: 16.0),
                _buildTextField(
                    controller: _surnameController,
                    label: 'Surname',
                    hint: 'Enter your surname'),
                const SizedBox(height: 16.0),
                _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16.0),
                _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 16.0),
                _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    obscureText: true),
                const SizedBox(height: 16.0),
                _buildTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    obscureText: true),
                const SizedBox(height: 16.0),
                _buildTextField(
                    controller: _ageController,
                    label: 'Age',
                    hint: 'Enter your age',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16.0),
                _buildDropdown(
                  label: 'Gender',
                  value: _gender,
                  items: ['Male', 'Female', 'Other'],
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildDropdown(
                  label: 'Marital Status',
                  value: _maritalStatus,
                  items: ['Single', 'Married', 'Divorced', 'Widowed'],
                  onChanged: (value) {
                    setState(() {
                      _maritalStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildDropdown(
                  label: 'Education Level',
                  value: _educationLevel,
                  items: ['High School', 'Undergraduate', 'Postgraduate'],
                  onChanged: (value) {
                    setState(() {
                      _educationLevel = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildRegionDropdown(),
                const SizedBox(height: 16.0),
                _buildDistrictDropdown(),
                const SizedBox(height: 16.0),
                _buildWardDropdown(),
                const SizedBox(height: 16.0),
                _buildTextField(
                    controller: _streetController,
                    label: 'Street',
                    hint: 'Enter your street address'),
                const SizedBox(height: 16.0),
                _buildSubjectSelection(),
                const SizedBox(height: 16.0),
                _buildCertificateUploadButton(),
                if (_certificateFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _certificateFile!.path.split('/').last,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 16.0),
                _buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hint';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildRegionDropdown() {
    return _buildDropdown(
      label: 'Region',
      value: _selectedRegion,
      items: _regions.map((region) => region['region'].toString()).toList(),
      onChanged: (value) {
        setState(() {
          _selectedRegion = value;
          _filterDistricts(value);
        });
      },
    );
  }

  Widget _buildDistrictDropdown() {
    return _buildDropdown(
      label: 'District',
      value: _selectedDistrict,
      items: _filteredDistricts,
      onChanged: (value) {
        setState(() {
          _selectedDistrict = value;
          _filterWards(value);
        });
      },
    );
  }

  Widget _buildWardDropdown() {
    return _buildDropdown(
      label: 'Ward',
      value: _selectedWard,
      items: _filteredWards,
      onChanged: (value) {
        setState(() {
          _selectedWard = value;
        });
      },
    );
  }

  Widget _buildSubjectSelection() {
    return MultiSelectDialogField(
      items: _subjects
          .map((subject) => MultiSelectItem(subject, subject))
          .toList(),
      title: const Text('Select Subjects'),
      selectedColor: const Color(0xFF0E424C),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(
          color: const Color(0xFF0E424C),
        ),
        color: const Color(0xFF0E424C),
      ),
      buttonIcon: const Icon(
        Icons.subject,
        color: Colors.white,
      ),
      buttonText: const Text(
        "Select subjects you teach",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onConfirm: (results) {
        setState(() {
          _selectedSubjects = results.cast<String>();
        });
      },
      chipDisplay: MultiSelectChipDisplay(
        onTap: (value) {
          setState(() {
            _selectedSubjects.remove(value.toString());
          });
        },
      ),
    );
  }

  Widget _buildCertificateUploadButton() {
    return ElevatedButton.icon(
      onPressed: _pickCertificate,
      icon: const Icon(Icons.upload_file),
      label: const Text('Upload Certificate'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffA0826A),
      ),
      child: _isLoading
          ? LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 24,
            )
          : const Text('Register'),
    );
  }
}
