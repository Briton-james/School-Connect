import 'package:flutter/material.dart';
import 'package:school_connect/screens/sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index
  final List<Widget> _pages = [
    // Your page widgets for each item (replace with your actual content)
    Center(
        child: ListView.builder(
          itemCount: 10, // Replace with your data source length
          itemBuilder: (context, index) => Container(
            width: double.infinity, // Allow max width within constraints
            constraints: const BoxConstraints(maxWidth: 300.0), // Set max card width
            child: Card(
              color: const Color(0xFF1061AD), // Set card background color (optional)
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column( // Main column for three-row layout
                  children: [
                    Row( // First row: image and paragraph
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0), // Image border radius
                          child: Image.asset(
                            'assets/images/chamazi.jpg',
                            width: 80.0, // Adjust image width
                            height: 80.0, // Adjust image height
                            fit: BoxFit.cover, // Scale image to fill container
                          ),
                        ),
                        const SizedBox(width: 16.0), // Spacing between image and text
                        const Expanded(
                          child: Text(
                            'This is a longer paragraph describing the content of the card. It can wrap to multiple lines.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0), // Spacing between rows
                    const Row( // Second row: bold text aligned left
                      children: [
                        Text(
                          'Mbande secondary school',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0), // Spacing between rows
                    Row( // Third row: icons with text and button, aligned to the right
                      mainAxisAlignment: MainAxisAlignment.end, // Align to right
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width: 8.0), // Spacing between icons
                        const Text('Chamazi',
                        style: TextStyle(
                          color: Colors.white
                        ),
                       ), // Text label for icon
                        const SizedBox(width: 8.0), // Spacing between text and icon
                        const Icon(Icons.timer_outlined),
                        const SizedBox(width: 8.0), // Spacing between icons
                        const Text('3 Months',
                        style: TextStyle(
                          color: Colors.white
                        ),
                       ), // Text label for icon
                        const SizedBox(width: 8.0), // Spacing between text and button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF68E1E)
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    ),

    Center(child: Text('Search')),
    Center(child: Text('Applications')),
    Center(child: Text('Profile')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF1061AD),
        appBar: AppBar(
          backgroundColor: const Color(0XFF1061AD),
          centerTitle: true,
          title: Image.asset(
            'assets/images/book.png',
            height: 25.0,
            width: 25.0,
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'All',),
              Tab(text: 'For you'),
            ],
          ),
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
              backgroundColor: Color(0xFF1061AD),
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
          selectedItemColor: Colors.orange, // Set color for selected item
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
