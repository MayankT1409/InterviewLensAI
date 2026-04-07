import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../services/auth_service.dart';
import '../utils/localization.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.t('Settings'), style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.t('General'), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
            const SizedBox(height: 12),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                   SwitchListTile(
                     title: Text(AppLocalizations.t('Push Notifications')),
                     value: _notificationsEnabled,
                     onChanged: (val) => setState(() => _notificationsEnabled = val),
                     secondary: const Icon(Icons.notifications_active_outlined),
                   ),
                   const Divider(height: 1),
                    SwitchListTile(
                      title: Text(AppLocalizations.t('Dark Mode')),
                      value: context.watch<ThemeProvider>().themeMode == ThemeMode.dark,
                      onChanged: (val) {
                        context.read<ThemeProvider>().toggleTheme(val);
                      },
                      secondary: const Icon(Icons.dark_mode_outlined),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(AppLocalizations.t('Notifications Center')),
                      subtitle: Text(AppLocalizations.t('Test alerts & scheduled reminders')),
                      leading: const Icon(Icons.notification_important_rounded, color: Colors.indigoAccent),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pushNamed(context, '/notifications'),
                    ),
                    const Divider(height: 1),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                     child: DropdownButtonFormField<String>(
                       decoration: InputDecoration(
                         labelText: AppLocalizations.t('App Language'),
                         border: InputBorder.none,
                         prefixIcon: const Icon(Icons.language_outlined),
                       ),
                       value: _selectedLanguage,
                       items: ['English', 'Hindi'].map((lang) {
                         return DropdownMenuItem(
                           key: ValueKey('lang_dropdown_$lang'),
                           value: lang, 
                           child: Text(AppLocalizations.t(lang))
                         );
                       }).toList(),
                       onChanged: (val) {
                         if (val != null) {
                           AppLocalizations.language = val;
                           setState(() => _selectedLanguage = val);
                         }
                       },
                     ),
                   ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Text(AppLocalizations.t('Support'), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
            const SizedBox(height: 12),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                   ListTile(
                     title: Text(AppLocalizations.t('Help Center')),
                     leading: const Icon(Icons.help_outline),
                     trailing: const Icon(Icons.chevron_right),
                     onTap: () {},
                   ),
                   const Divider(height: 1),
                   ListTile(
                     title: Text(AppLocalizations.t('Privacy Policy')),
                     leading: const Icon(Icons.privacy_tip_outlined),
                     trailing: const Icon(Icons.chevron_right),
                     onTap: () {},
                   ),
                    const Divider(height: 1),
                   ListTile(
                     title: Text(AppLocalizations.t('Terms of Service')),
                     leading: const Icon(Icons.description_outlined),
                     trailing: const Icon(Icons.chevron_right),
                     onTap: () {},
                   ),
                ],
              ),
            ),
             const SizedBox(height: 24),
             Text(AppLocalizations.t('Feedback'), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
             const SizedBox(height: 12),
             CustomCard(
               child: Form(
                 key: _formKey,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     TextFormField(
                       controller: _feedbackController,
                       decoration: InputDecoration(
                         labelText: AppLocalizations.t('Got any suggestions?'),
                         border: const OutlineInputBorder(),
                       ),
                       maxLines: 3,
                       validator: (value) {
                         if (value == null || value.trim().isEmpty) {
                           return AppLocalizations.t('Feedback cannot be empty');
                         }
                         return null;
                       },
                     ),
                     const SizedBox(height: 16),
                     ElevatedButton(
                       onPressed: () {
                         if (_formKey.currentState!.validate()) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text(AppLocalizations.t('Feedback submitted successfully! Thank you.'))),
                           );
                           _feedbackController.clear();
                         }
                       },
                       child: Text(AppLocalizations.t('Submit Feedback')),
                     ),
                   ],
                 ),
               ),
             ),
             const SizedBox(height: 24),
             SizedBox(
               width: double.infinity,
               child: OutlinedButton(
                 onPressed: () async {
                   final confirm = await showDialog<bool>(
                     context: context,
                     builder: (context) => AlertDialog(
                       title: Text(AppLocalizations.t('Logout')),
                       content: Text(AppLocalizations.t('Are you sure you want to log out of your account?')),
                       actions: [
                         TextButton(
                           onPressed: () => Navigator.pop(context, false),
                           child: Text(AppLocalizations.t('Cancel')),
                         ),
                         TextButton(
                           onPressed: () => Navigator.pop(context, true),
                           child: Text(AppLocalizations.t('Logout'), style: const TextStyle(color: Colors.red)),
                         ),
                       ],
                     ),
                   );

                   if (confirm == true) {
                     await _authService.signOut();
                     if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false);
                   }
                 },
                 style: OutlinedButton.styleFrom(
                   foregroundColor: Colors.red,
                   side: const BorderSide(color: Colors.red),
                   padding: const EdgeInsets.symmetric(vertical: 16),
                 ),
                 child: Text(AppLocalizations.t('LOGOUT')),
               ),
             ),
             const SizedBox(height: 16),
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
