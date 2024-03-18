import 'package:flutter/material.dart';
import 'package:school_connect/screens/home_screen.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFF1061AD),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: ListView(
            children: [
              Image.asset('assets/images/book.png',
                width: 100.0,
                height: 100.0,
              ),

              const SizedBox(
                height: 20.0,
              ),

              Center(
                child: RichText (text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'School',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      TextSpan(
                          children: [
                            TextSpan(
                              text: 'Connect',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ]
                      )
                    ]
                )
               ),
              ),

              const Text('Create an account',
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
                decoration: InputDecoration(
                  hintText: 'First name',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  )
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Surname',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  )
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'email',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular( 10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular( 10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'password',
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular( 10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              TextField(
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
              ),

              const SizedBox(
                height: 20.0,
              ),

              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                  //login logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                  maximumSize: const Size(150.0, 50.0),
                ),
                child: const Text('Sign up'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

