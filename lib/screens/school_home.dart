import 'package:flutter/material.dart';
import 'package:school_connect/components/listing_sheet.dart';

import '../components/school_application_contents.dart';
import '../components/school_home_contents.dart';
import '../components/school_profile_contents.dart';
import '../components/school_search_contents.dart';

class SchoolHomeScreen extends StatefulWidget {
  const SchoolHomeScreen({Key? key}) : super(key: key);

  @override
  _SchoolHomeScreenState createState() => _SchoolHomeScreenState();
}

class _SchoolHomeScreenState extends State<SchoolHomeScreen> {
  int _selectedIndex = 0; // Track the selected index
  final List<Widget> _pages = [
    // Home tab contents.
    const SchoolHomeContents(),

    //search tab contents.
    const SchoolSearchContents(),

    //Application tab contents.
    const SchoolApplicationContents(),

    //Profile tab contents.
    const SchoolProfileContents(),
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
                TextSpan(
                  text: 'Connect',
                  style: TextStyle(
                    color: Color(0xffA0826A),
                  ),
                ),
              ]),
            ),
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

      floatingActionButton: FloatingActionButton(
        onPressed: () => (showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const ListingSheet())), // Plus icon
        backgroundColor: const Color(0xffA0826A),
        child: const Icon(Icons.add), // Background color
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Adjust the FAB position
    );
  }
}
