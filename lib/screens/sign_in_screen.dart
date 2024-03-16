import 'package:flutter/material.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFF1061AD),
     body: Center(
       child: Padding(
         padding: const EdgeInsets.all(40.0),
         child: Column(
           children: [
             Image.asset('assets/images/book.png',
             width: 100.0,
               height: 100.0,
             ),
             const SizedBox(
               height: 20.0,
             ),
             RichText (text: const TextSpan(
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
             const Text('Welcome back',
             style: TextStyle(
               color: Colors.white,
               fontSize: 40.0,
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
             TextButton(
                              onPressed: (){},
               child: const Text('Forgot password',
               style: TextStyle(
                 color: Colors.orange,
                 ),
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
            )
           ],
         ),
       ),
     ),
    );
  }
}

