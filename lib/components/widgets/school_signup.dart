import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

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
      final String location = _locationController.text.trim();
      final String password = _passwordController.text.trim();

      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the current user UID
      final String uid = userCredential.user!.uid;

      // Add school details to Firestore using UID
      await addSchoolDetails(
        uid: uid,
        schoolName: schoolName,
        registrationNumber: registrationNumber,
        email: email,
        phoneNumber: phoneNumber,
        location: location,
        userType: 'school',
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

      // Navigate to sign-in screen after successful sign-up
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth errors
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
      // Handle other errors
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

  Future<void> addSchoolDetails(
      {required String uid,
      required String schoolName,
      required String registrationNumber,
      required String email,
      required String phoneNumber,
      required String location,
      required String userType}) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('schools').doc(uid);
      await docRef.set({
        'uid': uid, // Store UID for reference
        'schoolName': schoolName,
        'registrationNumber': registrationNumber,

        'email': email,
        'phoneNumber': phoneNumber,
        'location': location,
        'userType': 'school'
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
                    const SizedBox(
                      height: 20.0,
                    ),
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
                    const Text(
                      'Register School',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        //decoration: TextDecoration.underline,
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
                          return 'Please enter your school name';
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
                          return 'Please enter school\'s registration number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
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
                          return 'Please enter email';
                        }
                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+\w{2,4}$')
                            .hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
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
                            return 'Please enter phone number';
                          }
                          return null;
                        }),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText: 'Location',
                          filled: true,
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your school location';
                          }
                          return null;
                        }),
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
                          return 'Please enter a password';
                        }
                        if (!RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{8,}$')
                            .hasMatch(value)) {
                          return 'At least 8 characters and contain a mix of letters and numbers';
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
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _signUpSchool,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffA0826A),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 40.0,
                        ),
                        maximumSize: const Size(150.0, 50.0),
                      ),
                      child: const Text('Sign up'),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
      ),
    );
  }
}
