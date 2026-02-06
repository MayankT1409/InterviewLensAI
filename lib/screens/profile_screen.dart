import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'), // Placeholder
            ),
            const SizedBox(height: 16),
            Text(
              'John Doe',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Software Engineer Candidate',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            
            CustomCard(
              child: Column(
                children: [
                  _buildProfileItem(context, Icons.person_outline, 'Edit Profile', onTap: () {}),
                  _buildProfileItem(context, Icons.analytics_outlined, 'My Analytics', onTap: () {
                    Navigator.pushNamed(context, '/analytics');
                  }),
                  _buildProfileItem(context, Icons.notifications_none, 'Notifications', onTap: () {
                    Navigator.pushNamed(context, '/notifications');
                  }),
                  _buildProfileItem(context, Icons.settings_outlined, 'Settings', onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  }),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            CustomCard(
              child: _buildProfileItem(context, Icons.logout, 'Log Out', color: Colors.red, onTap: () {
                 Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String title, {Color? color, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).primaryColor),
      title: Text(title, style: TextStyle(color: color ?? Colors.black87)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }
}
