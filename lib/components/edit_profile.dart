import 'package:flutter/material.dart';
import 'package:school_connect/components/profile_contents.dart';
import 'package:school_connect/components/widgets/select_subject.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF1061AD),
      appBar: AppBar(
        backgroundColor: const Color(0XFF1061AD),
        title: const Text('Edit Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Personal details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileContents()));
                  },
                  child: const Text('Save'),
                )
              ],
            ),
            Card(
              color: const Color(0xff1061ad),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  // Wrap the inner Column with a Container
                  constraints:
                      const BoxConstraints(maxWidth: 300.0), // Set a max width
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Column for labels
                          Column(
                            children: [
                              Text("First Name:"),
                              SizedBox(height: 8.0),
                              Text('Surname'),
                              SizedBox(height: 8.0),
                              Text("Email:"),
                              SizedBox(height: 8.0),
                              Text("Phone Number:"),
                              SizedBox(height: 8.0),
                              Text('Location:')
                            ],
                          ),
                          Spacer(),
                          // Column for values
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kelvin'),
                              SizedBox(height: 8.0),
                              Text('Richard'),
                              SizedBox(height: 8.0),
                              Text('kelvin.richar@gmail.com'),
                              SizedBox(height: 8.0),
                              Text('0765896578'),
                              SizedBox(height: 8.0),
                              Text('Mwenge, Mpakani.')
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Volunteering Preferences',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Card(
              color: Color(0xff1061ad),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SubjectSelection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
