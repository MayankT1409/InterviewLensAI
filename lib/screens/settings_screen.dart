import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('General', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
            const SizedBox(height: 12),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                   SwitchListTile(
                     title: const Text('Push Notifications'),
                     value: _notificationsEnabled,
                     onChanged: (val) => setState(() => _notificationsEnabled = val),
                     secondary: const Icon(Icons.notifications_active_outlined),
                   ),
                   const Divider(height: 1),
                   SwitchListTile(
                     title: const Text('Dark Mode'),
                     value: _darkModeEnabled,
                     onChanged: (val) => setState(() => _darkModeEnabled = val),
                     secondary: const Icon(Icons.dark_mode_outlined),
                   ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Support', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
            const SizedBox(height: 12),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                   ListTile(
                     title: const Text('Help Center'),
                     leading: const Icon(Icons.help_outline),
                     trailing: const Icon(Icons.chevron_right),
                     onTap: () {},
                   ),
                   const Divider(height: 1),
                   ListTile(
                     title: const Text('Privacy Policy'),
                     leading: const Icon(Icons.privacy_tip_outlined),
                     trailing: const Icon(Icons.chevron_right),
                     onTap: () {},
                   ),
                    const Divider(height: 1),
                   ListTile(
                     title: const Text('Terms of Service'),
                     leading: const Icon(Icons.description_outlined),
                     trailing: const Icon(Icons.chevron_right),
                     onTap: () {},
                   ),
                ],
              ),
            ),
             const SizedBox(height: 24),
             Center(
               child: Text(
                 'Version 1.0.0',
                 style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
               ),
             )
          ],
        ),
      ),
    );
  }
}
