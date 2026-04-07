import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Center'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications_active_rounded,
                          size: 30, color: Colors.indigoAccent),
                      const SizedBox(width: 16),
                      Text(
                        'Push Triggers',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                      'Use the controls below to manually test local Push Notifications '
                      'and scheduled background relays directly simulating external server behavior.'),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Immediate Notification',
                    onPressed: () {
                      NotificationService().showImmediateNotification(
                        id: 0,
                        title: 'Interview Alert \u26A1',
                        body: 'This is an immediate local notification dropped in natively!',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Triggered Instant Alert!')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Schedule Notification (5 sec)',
                    isPrimary: false,
                    onPressed: () {
                      NotificationService().scheduleNotification(
                        id: 1,
                        title: 'Reminder Complete \u23F0',
                        body: 'This push was scheduled strictly 5 seconds ago running asynchronously.',
                        delay: const Duration(seconds: 5),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notification Armed for 5 seconds.')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomCard(
              child: Column(
                children: [
                  const Icon(Icons.cloud_sync_rounded, size: 40, color: Colors.blueAccent),
                  const SizedBox(height: 16),
                  Text(
                    'Firebase Cloud Messaging',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'FCM listeners are securely active. Background handlers and '
                    'active process foreground channels are automatically intercepted '
                    'and routed straight into the local OS pipeline.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
