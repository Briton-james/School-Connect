import 'package:flutter/material.dart';
import 'package:school_connect/models/notification.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;

  NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0E424C),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: const TextStyle(color: Colors.white),
            ),
            //
          ],
        ),
      ),
    );
  }
}
