import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SchoolSearchContents extends StatefulWidget {
  const SchoolSearchContents({super.key});

  @override
  _SchoolSearchContentsState createState() => _SchoolSearchContentsState();
}

class _SchoolSearchContentsState extends State<SchoolSearchContents> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Future<QuerySnapshot>? _searchResults;

  void _searchVolunteers() {
    setState(() {
      _searchQuery = _searchController.text.trim();
      if (_searchQuery.isNotEmpty) {
        _searchResults = FirebaseFirestore.instance
            .collection('users')
            .where('subjects', arrayContains: _searchQuery)
            .get();
      } else {
        _searchResults = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E424C),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search subjects..',
                hintFadeDuration: const Duration(seconds: 3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) => _searchVolunteers(),
            ),
            const SizedBox(height: 20),
            _searchResults == null
                ? Container()
                : FutureBuilder<QuerySnapshot>(
                    future: _searchResults,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text(
                          'No volunteers found for "$_searchQuery"',
                          style: const TextStyle(color: Colors.white),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final document = snapshot.data!.docs[index];
                            final volunteerData =
                                document.data() as Map<String, dynamic>;

                            return Card(
                              color: const Color(0xff34515e),
                              child: ListTile(
                                title: Text(
                                  volunteerData['firstname'] ?? 'No Name',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  volunteerData['email'] ?? 'No Email',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: Text(
                                  (volunteerData['subjects'] as List<dynamic>)
                                      .join(', '),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
