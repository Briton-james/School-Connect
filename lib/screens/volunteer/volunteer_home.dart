import 'package:flutter/material.dart';
import 'package:school_connect/components/volunteer/application_contents.dart';
import 'package:school_connect/components/volunteer/home_contents.dart';
import 'package:school_connect/components/volunteer/notifications_contents.dart';
import 'package:school_connect/components/volunteer/profile_contents.dart';
import 'package:school_connect/components/volunteer/request_contents.dart';

import '../../components/volunteer/volunteer_search.dart';

class VolunteerHomeScreen extends StatefulWidget {
  const VolunteerHomeScreen({super.key});

  @override
  _VolunteerHomeScreenState createState() => _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends State<VolunteerHomeScreen> {
  int _selectedIndex = 0; // Track the selected index
  final List<Widget> _pages = [
    const HomeContents(),
    const VolunteerSearchContents(),
    const ApplicationContents(),
    const VolunteerRequests(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
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
            const SizedBox(width: 20.0),
            RichText(
              text: const TextSpan(
                children: [
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
                ],
              ),
            ),
          ],
        ),
        titleSpacing: 40.0,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (Context) => const ProfileContents()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
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
            icon: Icon(Icons.north_east),
            label: 'Applications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.south_west),
            label: 'Requests',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xffA0826A),
        onTap: _onItemTapped,
      ),
    );
  }
}
