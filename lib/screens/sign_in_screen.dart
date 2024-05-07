import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:school_connect/backend/firebase_auth_services.dart';
import 'package:school_connect/screens/reset_password_screen.dart';
import 'package:school_connect/screens/school_home.dart';
import 'package:school_connect/screens/sign_up_screen.dart';
import 'package:school_connect/screens/volunteer_home.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isEmailValid = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePasswordMatch);
    _emailController.addListener(_validateEmail);
  }

  void _validatePasswordMatch() {
    setState(() {});
  }

  void _validateEmail() {
    setState(() {
      _isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(_emailController.text);
    });
  }

  bool _validateFields() {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E424C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
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
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'Welcome back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  //decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _isEmailValid ? null : 'Invalid email',
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ForgotPasswordDialog(),
                  );
                },
                child: const Text(
                  'Forgot password',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xffA0826A),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              _isLoading
                  ? LoadingAnimationWidget.fourRotatingDots(
                      color: const Color(0xffA0826A),
                      size: 50,
                    )
                  : ElevatedButton(
                      onPressed: () {
                        if (_validateFields() && _isEmailValid) {
                          setState(() {
                            _isLoading =
                                true; // Set loading flag to true before sign-in
                          });

                          _signIn();
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Provide your correct credentials to sign in!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              textColor: const Color(0xffA0826A),
                              fontSize: 14.0,
                              backgroundColor: const Color(0xff0E424C));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffA0826A),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 40.0),
                      ),
                      child: const Text('Sign in'),
                    ),
              const SizedBox(
                height: 30.0,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text(
                  'New here? Sign up',
                  style: TextStyle(
                    color: Color(0xffA0826A),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

// Sign in method
  Future<void> _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      final User? user =
          await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        // Retrieve user type
        String? userType = await FirebaseAuthServices().getUserType(user.uid);
        print('User type: $userType'); // Add this line for debugging

        // Redirect to the appropriate screen based on user type
        if (userType == 'school') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SchoolHomeScreen()),
          );
        } else if (userType == 'volunteer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const VolunteerHomeScreen()),
          );
        } else {
          // Handle the case where user type is not defined
          print('User type not defined');
        }
      } else {
        print("An error occurred during sign in");
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
    } catch (e) {
      print(e); // Log other unexpected errors
    }
  }

  void _handleFirebaseAuthException(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      // Display a message to the user that the password is weak
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      // Display a message to the user that the email is already in use
    } else if (e.code == 'invalid-email') {
      print('The email address is invalid.');
      // Display a message to the user that the email is invalid
    } else if (e.code == 'user-not-found') {
      print('The user does not exist.');
      // Display a message to the user that the user does not exist
    } else if (e.code == 'wrong-password') {
      print('The password is incorrect.');
      // Display a message to the user that the password is incorrect
    } else {
      print(e); // Log other unexpected FirebaseAuthExceptions
    }
  }
}

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Password'),
      content: const Text(
          'An email with a link to rest password will be sent to your registered email address'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ResetPassword(),
              ),
            );
          },
          child: const Text('Continue'),
        )
      ],
    );
  }
}
