import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  double _getMetricScore(String? metric) {
    if (metric == null) return 0.0;
    final lower = metric.toLowerCase();
    if (lower.contains('high') || lower.contains('good') || lower.contains('fast')) return 1.0;
    if (lower.contains('medium')) return 0.6;
    if (lower.contains('low') || lower.contains('poor') || lower.contains('slow')) return 0.3;
    return 0.5;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final firestoreService = FirestoreService();

    if (userId == null) return const Center(child: Text("Please login"));

    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Analytics', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getUserHistory(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final history = snapshot.data!;
          
          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.analytics_outlined, size: 64, color: Colors.grey[300]),
                   const SizedBox(height: 16),
                   Text("No analytics available yet.", style: TextStyle(color: Colors.grey[500])),
                   Text("Complete an interview first.", style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }

          int totalSessions = history.length;
          double totalScore = 0;
          double totalConfidence = 0;
          double totalPacing = 0;
          double totalClarity = 0;
          double totalEyeContact = 0;

          for (var item in history) {
            final scoreString = item['score'] ?? item['overallScore'] ?? 0;
            totalScore += num.tryParse(scoreString.toString()) ?? 0;
            
            final metrics = item['metrics'] ?? {};
            totalConfidence += _getMetricScore(metrics['confidence']);
            totalPacing += _getMetricScore(metrics['pacing']);
            totalClarity += _getMetricScore(metrics['clarity']);
            totalEyeContact += _getMetricScore(metrics['eyeContact']);
          }

          double avgScore = totalScore / totalSessions;
          double avgConfidence = totalConfidence / totalSessions;
          double avgPacing = totalPacing / totalSessions;
          double avgClarity = totalClarity / totalSessions;
          double avgEyeContact = totalEyeContact / totalSessions;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Summary Cards
                Row(
                  children: [
                    _buildSummaryCard(context, 'Total Sessions', '$totalSessions', Icons.videocam, Colors.blue),
                    const SizedBox(width: 16),
                    _buildSummaryCard(context, 'Avg Score', '${avgScore.toStringAsFixed(0)}%', Icons.analytics, Colors.green),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Skill Breakdown
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Skill Breakdown', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 24),
                      _buildSkillBar(context, 'Confidence', avgConfidence),
                      _buildSkillBar(context, 'Clarity', avgClarity),
                      _buildSkillBar(context, 'Pacing', avgPacing),
                      _buildSkillBar(context, 'Eye Contact', avgEyeContact),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          );
        },
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
