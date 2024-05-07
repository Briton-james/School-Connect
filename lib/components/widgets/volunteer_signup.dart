import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

  bool _isLoading = false;

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

        // Add user details to Firestore using UID
        await addUserDetails(
          firstname: _firstNameController.text.trim(),
          surname: _surnameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          userType: 'volunteer',
        );

        print("Account created successful!");
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
      {required String firstname,
      required String surname,
      required String email,
      required String phone,
      required String userType}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final uid = user.uid;

        final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
        await docRef.set({
          'uid': uid, // Store UID for reference
          'firstname': firstname,
          'surname': surname,
          'email': email,
          'phone': phone,
          'userType': 'volunteer'
        });

        print("User data added successfully!");
      } else {
        print("No user signed in");
      }
    } catch (e) {
      print("Error adding user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        child: Form(
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
                'Create an account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  //decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: 'First name',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(
                  hintText: 'Surname',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your surname';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
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
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Phone number.',
                    filled: true,
                    fillColor: Colors.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 20.0,
              ),
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
                  } else if (!RegExp(
                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{8,}$')
                      .hasMatch(value)) {
                    return 'At least 8 characters and contain a mix of letters and numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
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
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              _isLoading
                  ? Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: const Color(0xffA0826A),
                        size: 50.0,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffA0826A),
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
