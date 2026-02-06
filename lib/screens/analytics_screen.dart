import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Analytics', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Summary Cards
            Row(
              children: [
                _buildSummaryCard(context, 'Total Sessions', '12', Icons.videocam, Colors.blue),
                const SizedBox(width: 16),
                _buildSummaryCard(context, 'Avg Score', '78%', Icons.analytics, Colors.green),
              ],
            ),
            const SizedBox(height: 24),
            
            // Skill Breakdown (Placeholder for Chart)
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Skill Breakdown', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24),
                  _buildSkillBar(context, 'Technical', 0.8),
                  _buildSkillBar(context, 'Communication', 0.65),
                  _buildSkillBar(context, 'Confidence', 0.9),
                  _buildSkillBar(context, 'Problem Solving', 0.75),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent Trends
             CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Trends', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: Text('Performance Graph Placeholder', style: TextStyle(color: Colors.grey)),
                    // In a real app, use fl_chart or similar
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: CustomCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 16),
            Text(value, style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            )),
            Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillBar(BuildContext context, String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyLarge),
              Text('${(value * 100).toInt()}%', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[200],
            color: Theme.of(context).primaryColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
