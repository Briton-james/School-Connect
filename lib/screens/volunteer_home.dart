import 'package:flutter/material.dart';
import 'package:school_connect/components/application_contents.dart';
import 'package:school_connect/components/home_contents.dart';
import 'package:school_connect/components/profile_contents.dart';
import 'package:school_connect/components/search_contents.dart';

class VolunteerHomeScreen extends StatefulWidget {
  const VolunteerHomeScreen({super.key});

  @override
  _VolunteerHomeScreenState createState() => _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends State<VolunteerHomeScreen> {
  int _selectedIndex = 0; // Track the selected index
  final List<Widget> _pages = [
    // Home tab contents.
    const HomeContents(),

    //search tab contents.
    const SearchContents(),

    //Application tab contents.
    const ApplicationContents(),

    //Profile tab contents.
    const ProfileContents(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E424C),
      appBar: AppBar(
        backgroundColor: const Color(0XFF0E424C),
        centerTitle: true,
        title: Row(
          children: [
            Image.asset(
              'assets/images/book.png',
              height: 25.0,
              width: 25.0,
            ),
            const SizedBox(
              width: 20.0,
            ),
            RichText(
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
            ])),
          ],
        ),
        titleSpacing: 60.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              //show notifications
            },
          ),
        ],
      ),

      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF0E424C),
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Applications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            const Color(0xffA0826A), // Set color for selected item
        onTap: _onItemTapped,
      ),
    );
  }
}
