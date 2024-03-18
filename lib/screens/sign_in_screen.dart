import 'package:flutter/material.dart';
import 'package:school_connect/screens/sign_up_screen.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFF1061AD),
     body: Center(
       child: Padding(
         padding: const EdgeInsets.all(40.0),
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
               )),
             ),
             const SizedBox(
               height: 30.0,
             ),
             const Text('Welcome back',
             style: TextStyle(
               color: Colors.white,
               fontSize: 30.0,
               //decoration: TextDecoration.underline,
             ),),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your email',
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
                 hintText: 'Enter your password',
                 filled: true,
                 fillColor: Colors.grey,
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10.0),
                   borderSide: BorderSide.none,
                 ),
               ),
             ),
             ListTile(
               title: Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   TextButton(
                     onPressed: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpScreen()));
                     },
                     child: const Text('Forgot password',
                       style: TextStyle(
                         color: Colors.orange,
                       ),
                     ),
                   ),
                 ],
               ),
             ),

            const SizedBox(
              height: 20.0,
            ),

            ElevatedButton(
                onPressed: (){
              //login logic
            },
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.orange,
               padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
             ),
            child: const Text('Sign in'),
            ),
             const SizedBox(
               height: 30.0,
             ),
             TextButton(
               onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpScreen()));
               },
               child: const Text('New here? Sign up',
                 style: TextStyle(
                   color: Colors.orange,
                 ),
               ),
             ),
           ],
         ),
       ),
     ),
    );
  }
}

