import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Note: In a real app we would import the actual auth/dashboard screen here.
// For now, we will navigate to a placeholder or the next screen.
import '../widgets/custom_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a gradient background for a modern feel
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF5F7FA), // Light cool gray/blue
              const Color(0xFFE4E7EB),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Logo / Icon Placeholder
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.videocam_rounded,
                    size: 64,
                    color: Color(0xFF2563EB), // Primary Blue
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                Text(
                  'InterviewLens',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                // Tagline
                Text(
                  'Master your interview skills with\nreal-time AI feedback.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const Spacer(flex: 3),
                // Get Started Button
                CustomButton(
                  text: 'Get Started',
                  onPressed: () {
                    // Navigate to Dashboard (skipping auth for prototype simplicity per plan?)
                    // Or navigate to a temporary placeholder.
                    // Let's assume we go to a Dashboard placeholder.
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                ),
                const SizedBox(height: 16),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
