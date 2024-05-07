import 'package:flutter/material.dart';
import 'package:school_connect/components/widgets/listing_information.dart';

import 'widgets/select_subject.dart';

class ApplicationSheet extends StatelessWidget {
  const ApplicationSheet({super.key});

  //get screen height
  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenHeight(context) *
          0.70, //Bottom sheet to cover 90% of screen size
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          color: Color(0xff0E424C)),
      child: Card(
        color: const Color(0xff0E424C),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Container(
                    width: 50.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  const Spacer()
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              const ListingInformation(),
              const Spacer(),
              const Row(
                children: [
                  Text(
                    "Subjects you can teach:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SubjectSelection(),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffA0826A)),
                onPressed: () {},
                child: const Text('Submit application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
