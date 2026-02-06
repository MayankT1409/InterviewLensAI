import 'dart:math';

class AIService {
  // Simulate AI analysis
  Future<Map<String, dynamic>> generateFeedback(String interviewId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final random = Random();
    final score = 70 + random.nextInt(25); // Score between 70-95

    return {
      'score': score,
      'summary': _getSummary(score),
      'metrics': {
        'confidence': _getMetricLevel(score),
        'pacing': 'Good',
        'clarity': _getMetricLevel(score + 5),
        'eyeContact': 'Fair',
      },
      'insights': [
        'Try to reduce usage of filler words like "um" and "uh".',
        'Excellent structure in your STAR method response.',
        'Consider elaborating more on the "Result" part of your answers.',
      ]
    };
  }

  String _getSummary(int score) {
    if (score >= 90) return 'Outstanding!';
    if (score >= 80) return 'Great Job!';
    if (score >= 70) return 'Good Effort';
    return 'Needs Improvement';
  }

  String _getMetricLevel(int score) {
    if (score >= 90) return 'High';
    if (score >= 80) return 'Good';
    return 'Moderate';
  }
}
