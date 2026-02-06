import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';

class InterviewInstructionsScreen extends StatelessWidget {
  const InterviewInstructionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.tips_and_updates_outlined, 
                    size: 48, 
                    color: Theme.of(context).primaryColor
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Before You Start',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInstructionItem(context, '1. Ensure you are in a quiet environment.'),
                  _buildInstructionItem(context, '2. Check your microphone and camera.'),
                  _buildInstructionItem(context, '3. Speak clearly and concisely.'),
                  _buildInstructionItem(context, '4. You will have 5 questions to answer.'),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Start Interview',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/interview-session');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
