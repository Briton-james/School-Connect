import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants/location_services.dart';
import '../../screens/sign_in_screen.dart';

class SchoolSignUpForm extends StatefulWidget {
  const SchoolSignUpForm({Key? key}) : super(key: key);

  @override
  _SchoolSignUpFormState createState() => _SchoolSignUpFormState();
}

class _SchoolSignUpFormState extends State<SchoolSignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _regNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _schoolType;
  String? _isReligious;
  String? _religionType;
  String? _isBoarding;
  String? _genderComposition;
  int? _numberOfStudents;

  String? _selectedRegion;
  String? _selectedDistrict;
  List<dynamic> _regions = [];
  List<dynamic> _districts = [];

  String? _selectedWard;
  List<String> _filteredDistricts = [];
  List<String> _filteredWards = [];

  bool _isLoading = false;

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

  Future<void> _signUpSchool() async {
    if (!_validateFields()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String schoolName = _schoolNameController.text.trim();
      final String registrationNumber = _regNumberController.text.trim();
      final String email = _emailController.text.trim();
      final String phoneNumber = _phoneNumberController.text.trim();
      final String street = _streetController.text.trim();
      final String password = _passwordController.text.trim();

      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final String uid = userCredential.user!.uid;

      await addSchoolDetails(
        uid: uid,
        schoolName: schoolName,
        registrationNumber: registrationNumber,
        email: email,
        phoneNumber: phoneNumber,
        region: _selectedRegion!,
        district: _selectedDistrict!,
        ward: _selectedWard!,
        street: street,
        userType: 'school',
        schoolType: _schoolType,
        isReligious: _isReligious,
        religionType: _religionType,
        isBoarding: _isBoarding,
        genderComposition: _genderComposition,
        numberOfStudents: _numberOfStudents,
      );

      print("School account created successfully!");
      Fluttertoast.showToast(
        msg: "School account created successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: $e");
      String errorMessage = "An error occurred. Please try again.";
      if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The account already exists for that email.";
      }
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print("Error: $e");
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addSchoolDetails({
    required String uid,
    required String schoolName,
    required String registrationNumber,
    required String email,
    required String phoneNumber,
    required String region,
    required String district,
    required String ward,
    required String street,
    required String userType,
    String? schoolType,
    String? isReligious,
    String? religionType,
    String? isBoarding,
    String? genderComposition,
    int? numberOfStudents,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('schools').doc(uid);
      await docRef.set({
        'uid': uid,
        'schoolName': schoolName,
        'registrationNumber': registrationNumber,
        'email': email,
        'phoneNumber': phoneNumber,
        'region': region,
        'district': district,
        'ward': ward,
        'street': street,
        'userType': userType,
        'schoolType': schoolType,
        'isReligious': isReligious,
        'religionType': religionType,
        'isBoarding': isBoarding,
        'genderComposition': genderComposition,
        'numberOfStudents': numberOfStudents,
      });

      print("School data added successfully!");
    } catch (e) {
      print("Error adding school data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        child: _isLoading
            ? LoadingAnimationWidget.fourRotatingDots(
                color: const Color(0xffA0826A),
                size: 50,
              )
            : Form(
                key: _formKey,
                child: ListView(
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
                      'Register School',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _schoolNameController,
                      decoration: InputDecoration(
                        hintText: 'School name',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the school name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _regNumberController,
                      decoration: InputDecoration(
                        hintText: 'Registration number',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the registration number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        hintText: 'Phone number',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'Select Region',
                            filled: true,
                            fillColor: Colors.grey,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: _selectedRegion,
                          items: _regions
                              .map((region) => DropdownMenuItem<String>(
                                    value: region['region'] as String,
                                    child: Text(region['region']),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRegion = value;
                              _filterDistricts(value);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a region';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        if (_selectedRegion != null)
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Select District',
                              filled: true,
                              fillColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            value: _selectedDistrict,
                            items: _filteredDistricts
                                .map((district) => DropdownMenuItem<String>(
                                      value: district,
                                      child: Text(district),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDistrict = value;
                                _filterWards(value);
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a district';
                              }
                              return null;
                            },
                          ),
                        const SizedBox(height: 20.0),
                        if (_selectedDistrict != null)
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Select Ward',
                              filled: true,
                              fillColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            value: _selectedWard,
                            items: _filteredWards
                                .map((ward) => DropdownMenuItem<String>(
                                      value: ward,
                                      child: Text(ward),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedWard = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a ward';
                              }
                              return null;
                            },
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _streetController,
                      decoration: InputDecoration(
                        hintText: 'Street',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the street';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    DropdownButtonFormField<String>(
                      value: _schoolType,
                      decoration: InputDecoration(
                        hintText: 'School Type',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: ['Government', 'Private']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _schoolType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the school type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    if (_schoolType == 'Private')
                      Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _isReligious,
                            decoration: InputDecoration(
                              hintText: 'Is the school religious?',
                              filled: true,
                              fillColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: ['Yes', 'No']
                                .map((answer) => DropdownMenuItem(
                                      value: answer,
                                      child: Text(answer),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _isReligious = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select if the school is religious';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    if (_isReligious == 'Yes')
                      Column(
                        children: [
                          const SizedBox(height: 20.0),
                          DropdownButtonFormField<String>(
                            value: _religionType,
                            decoration: InputDecoration(
                              hintText: 'Select school religion',
                              filled: true,
                              fillColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: ['Christianity', 'Islamic']
                                .map((answer) => DropdownMenuItem(
                                      value: answer,
                                      child: Text(answer),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _religionType = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select religion';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    const SizedBox(height: 20.0),
                    DropdownButtonFormField<String>(
                      value: _isBoarding,
                      decoration: InputDecoration(
                        hintText: 'Boarding  school?',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: ['Yes', 'No']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _isBoarding = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select if the school is boarding or day';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    DropdownButtonFormField<String>(
                      value: _genderComposition,
                      decoration: InputDecoration(
                        hintText: 'Gender composition',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: ['Boys', 'Girls', 'Mixed']
                          .map((composition) => DropdownMenuItem(
                                value: composition,
                                child: Text(composition),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _genderComposition = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the gender composition';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Number of students',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _numberOfStudents = int.tryParse(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of students';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm the password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signUpSchool();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffA0826A),
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
