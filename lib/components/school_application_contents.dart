import 'package:flutter/material.dart';

class SchoolApplicationContents extends StatelessWidget {
  const SchoolApplicationContents({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 300.0),
          child: Card(
            color: const Color(0xff0E424C),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      'assets/images/chamazi.jpg',
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    'Chamazi Sec. School',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'In need of 4 teachers for Chemistry, Mathematics, Biology and Geography, one teacher each.',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Row(
                    children: [
                      Icon(Icons.cottage_outlined),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        'Accommodation provided by the school.',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text('Chamazi'),
                      SizedBox(
                        width: 20.0,
                      ),
                      Icon(Icons.timer_outlined),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text('2 Months'),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Subjects:',
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      const Text('Application status:'),
                      const Spacer(
                        flex: 1,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffA0826A)),
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
    );
  }
}
