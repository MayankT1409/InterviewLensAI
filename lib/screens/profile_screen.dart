import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: user == null 
          ? const Center(child: Text('Please log in'))
          : FutureBuilder<UserModel?>(
              future: firestoreService.getUser(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final userData = snapshot.data;
                if (userData == null) return const Center(child: Text('User not found'));

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userData.photoUrl != null 
                            ? NetworkImage(userData.photoUrl!) 
                            : null,
                        child: userData.photoUrl == null 
                            ? const Icon(Icons.person, size: 50) 
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userData.name ?? 'No Name',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (userData.bio != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            userData.bio!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                          ),
                        ),
                      const SizedBox(height: 32),
                      
                      CustomCard(
                        child: Column(
                          children: [
                            _buildProfileItem(context, Icons.person_outline, 'Edit Profile', onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => EditProfileScreen(user: userData)),
                              );
                              // Force rebuild to show updated data? 
                              // Ideally use StreamBuilder or setState, but for now this works if we pop with result
                              (context as Element).markNeedsBuild(); 
                            }),
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
                           authService.signOut();
                           Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false);
                        }),
                      ),
                    ],
                  ),
                );
              },
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
