import 'dart:convert';
import 'dart:math';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class AIService {
  // TODO: Replace with your actual Gemini API Key
  static const String _apiKey = 'AIzaSyDsmJbBOAl44WcKKtePYQFJeXIKRJ11Yik'; 

  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<Map<String, dynamic>> generateFeedback(String interviewQuestion, String userAnswer) async {
    try {
      // Note: interviewQuestion might now be "Full Session" and userAnswer contains the transcript
      final prompt = '''
        You are an expert technical interviewer.
        
        The following is a transcript of an interview session:
        "$userAnswer"

        Evaluate the candidate's performance across all questions. 
        Provide a JSON response with the following fields:
        - score: (integer 0-100, overall performance)
        - summary: (string, brief summary of strengths and weaknesses)
        - metrics: { "confidence": "High/Medium/Low", "pacing": "Fast/Good/Slow", "clarity": "High/Medium/Low", "eyeContact": "Good/Poor" }
        - insights: (list of strings, 3 specific constructive tips based on specific answers)
        
        Return ONLY the JSON. No markdown formatting.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final responseText = response.text;
      if (responseText == null) throw Exception('No response from AI');

      if (kDebugMode) {
        print('AI Raw Response: $responseText');
      }

      // Robust JSON cleanup
      String jsonString = responseText.trim();
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.replaceAll('```json', '').replaceAll('```', '');
      } else if (jsonString.startsWith('```')) {
         jsonString = jsonString.replaceAll('```', '');
      }
      
      jsonString = jsonString.trim();
      
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return data;

    } catch (e) {
      if (kDebugMode) {
        print('AI Service Error: $e');
      }
      // Return safe fallback instead of throwing or returning null (though return type is non-nullable Future)
      return {
        'score': 0,
        'summary': 'Unable to generate feedback at this time.',
        'metrics': {
          'confidence': 'N/A', 
          'clarity': 'N/A', 
          'relevance': 'N/A'
        },
        'insights': [
          'An error occurred while analyzing your response.',
          'Please check your internet connection and try again.',
          'Error details: ${e.toString().substring(0, min(e.toString().length, 50))}...'
        ]
      };
    }
  }
}
