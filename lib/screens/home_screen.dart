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
    // Home tab
    Center(
        child: ListView.builder(
          itemCount: 10, // Replace with your data source length
          itemBuilder: (context, index) => Container(
            width: double.infinity, // Allow max width within constraints
            constraints: const BoxConstraints(maxWidth: 300.0), //Max card width
            child: Card(
              color: const Color(0xFF1061AD), // Card background color
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
                            'In need of 4 teachers for Chemistry, Mathematics, Biology and Geography, one teacher each.',
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

    //search tab
    Center(child: Scaffold(
      backgroundColor: const Color(0xff1061ad),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child:  TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey,
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search schools, subjects..',
            hintFadeDuration: const Duration(seconds: 3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none
            ),
          ),
        ),
      ),
    ),
    ),


    //Application tab
    Center(child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 300.0),
          child: Card(
            color: const Color(0xff1061ad),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset('assets/images/chamazi.jpg',
                    width: 50.0,
                    height: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text('Chamazi Sec. School',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                  ),
                  const SizedBox(height: 10.0,),
                  const Text('In need of 4 teachers for Chemistry, Mathematics, Biology and Geography, one teacher each.',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
                  const SizedBox(height: 10.0,),
                  const Row(
                    children: [
                      Icon(Icons.cottage_outlined),
                      SizedBox(width: 4.0,),
                      Text('Accommodation provided by the school.',
                      style: TextStyle(
                        color: Colors.white
                      ),
                     )
                    ],
                  ),
                  const SizedBox(height: 8.0,),
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      SizedBox(width: 4.0,),
                      Text('Chamazi'),
                      SizedBox(width: 20.0,),
                      Icon(Icons.timer_outlined),
                      SizedBox(width: 4.0,),
                      Text('2 Months'),
                    ],
                  ),
                  const SizedBox(height: 8.0,),
                  const Row(
                    children: [
                      Text('Subjects:',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Chemistry'),
                      Text('Physics'),
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  Row(
                    children: [
                      const Text('Application status:'),
                      const Spacer(
                        flex: 1,
                      ),
                      ElevatedButton(
                          onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                      ),
                          child: const Text('Accepted!'),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    ),
    ),

    Center(child: Text('Profile')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1061AD),
      appBar: AppBar(
        backgroundColor: const Color(0XFF1061AD),
        centerTitle: true,
        title: Row(
          children: [
            Image.asset(
              'assets/images/book.png',
              height: 25.0,
              width: 25.0,
            ),
            const SizedBox(width: 20.0,),
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
                            color: Colors.orange,
                          ),
                        ),
                      ]
                  )
                ]
            )
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
    );
  }
}
