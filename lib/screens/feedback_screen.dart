import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    // Default values if no args provided (fallback)
    final score = args?['score'] ?? 85;
    final summary = args?['summary'] ?? 'Great Job!';
    final metrics = args?['metrics'] as Map<String, dynamic>? ?? {
      'confidence': 'High', 'pacing': 'Good', 'clarity': 'Excellent', 'eyeContact': 'Fair'
    };
    final insights = args?['insights'] as List<dynamic>? ?? [
      'Try to reduce usage of filler words like "um" and "uh".',
      'Excellent structure in your STAR method response.'
    ];

    Color scoreColor = const Color(0xFF10B981); // Green
    if (score < 70) scoreColor = Colors.orange;
    if (score < 50) scoreColor = Colors.red;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Session Feedback', style: Theme.of(context).textTheme.titleLarge),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (route) => false),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
             // Score
             Stack(
               alignment: Alignment.center,
               children: [
                 SizedBox(
                   width: 160,
                   height: 160,
                   child: CircularProgressIndicator(
                     value: score / 100,
                     strokeWidth: 12,
                     backgroundColor: Colors.grey[100],
                     color: scoreColor,
                   ),
                 ),
                 Column(
                   children: [
                     Text(
                       '$score%',
                       style: Theme.of(context).textTheme.displaySmall?.copyWith(
                         fontWeight: FontWeight.bold,
                         color: const Color(0xFF1E293B),
                       ),
                     ),
                     Text(
                       summary,
                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                         color: Colors.grey[500],
                       ),
                     ),
                   ],
                 )
               ],
             ),
             const SizedBox(height: 32),
             
             // Metrics Grid
             Row(
               children: [
                 _buildMetricCard(context, 'Confidence', metrics['confidence'], Colors.purple),
                 const SizedBox(width: 16),
                 _buildMetricCard(context, 'Pacing', metrics['pacing'], Colors.blue),
               ],
             ),
             const SizedBox(height: 16),
             Row(
               children: [
                 _buildMetricCard(context, 'Clarity', metrics['clarity'], Colors.orange),
                 const SizedBox(width: 16),
                  _buildMetricCard(context, 'Eye Contact', metrics['eyeContact'], Colors.red),
               ],
             ),

             const SizedBox(height: 32),
             Align(
               alignment: Alignment.centerLeft,
               child: Text('AI Insights', 
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
               ),
             ),
             const SizedBox(height: 16),
             ...insights.map((insight) => _buildInsightItem(context, Icons.lightbulb_outline, insight.toString())),
             
             const SizedBox(height: 48),
             CustomButton(
              text: 'Back to Dashboard',
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (route) => false);
              },
             )
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String label, String value, MaterialColor color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color[50], // Very light shade
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color[700],
            )),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color[900],
              fontWeight: FontWeight.bold
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[600], size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.5,
            color: Colors.grey[800]
          ))),
        ],
      ),
    );
  }
}
