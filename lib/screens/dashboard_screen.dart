import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import 'candidate_dashboard_screen.dart';
import 'interviewer_dashboard_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final user = authService.currentUser;

    if (user == null) {
      // Should not happen if guarded, but safe fallback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return FutureBuilder<UserModel?>(
      future: firestoreService.getUser(user.uid).timeout(const Duration(seconds: 10)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your profile...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
           return Scaffold(
             body: Center(
               child: Padding(
                 padding: const EdgeInsets.all(24.0),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Icon(Icons.error_outline, color: Colors.red, size: 48),
                     const SizedBox(height: 16),
                     Text(
                       'Error loading profile',
                       style: Theme.of(context).textTheme.titleLarge,
                     ),
                     const SizedBox(height: 8),
                     Text(
                       '${snapshot.error}',
                       textAlign: TextAlign.center,
                       style: TextStyle(color: Colors.grey[600]),
                     ),
                     const SizedBox(height: 24),
                     ElevatedButton(
                       onPressed: () {
                         // Triggers rebuild
                         (context as Element).markNeedsBuild();
                       },
                       child: const Text('Retry'),
                     ),
                     TextButton(
                       onPressed: () => authService.signOut(),
                       child: const Text('Logout'),
                     ),
                   ],
                 ),
               ),
             ),
           );
        }

        final userModel = snapshot.data;
        if (userModel == null) {
           // Fallback if data missing - Maybe assume Candidate or show error?
           // For now, default to Candidate to avoid blocking.
           return const CandidateDashboardScreen();
        }

        if (userModel.role == 'interviewer') {
          return const InterviewerDashboardScreen();
        } else {
          return const CandidateDashboardScreen();
        }
      },
    );
  }
}
