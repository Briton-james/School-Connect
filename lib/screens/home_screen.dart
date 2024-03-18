import 'package:flutter/material.dart';  // Import the material library

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF1061AD),
        appBar: AppBar(
          leading: const Icon(
            Icons.arrow_back,
            color: Color(0xFFF68E1E),
          ),
          backgroundColor: const Color(0xFF1061AD),
          titleSpacing: 0.0, // Remove default spacing between widgets

          // Row for flexible arrangement of search bar and tabs
          title: Row(
            children: [
              const TabBar( // Tabs on the right with start alignment
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'For you'),
                ],
              ),

              Expanded(
                // flex: 2,
                child: TextField(

                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(
                width: 50.0,
              ),
            ],
          ),
          actions: const [
            Icon(
              Icons.notifications,
              color: Color(0xFFF68E1E),
            )
          ],
        ),
        body: const TabBarView(
          children: [
            Center(
              child: Text('All'),
            ),
            Center(
              child: Text('For you'),
            )
          ],
        ),
      ),
    );
  }
}
