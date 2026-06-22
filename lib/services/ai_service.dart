import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class AIService {
  // TODO: Replace with your actual Gemini API Key
  static const String _apiKey = 'AIzaSyA-7TAup0ZlhICx_WhECoklRBnDtzhu8us';

  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(
      model: 'models/gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<Map<String, dynamic>> generateFeedback(String interviewQuestion, String userAnswer) async {
    try {
      // 1. Pre-check: If the transcript is virtually empty, return a helpful hint
      // We check if there's any substantial text after "Answer: "
      final answers = RegExp(r'Answer:\s*(.+)').allMatches(userAnswer);
      final totalAnswerLength = answers.fold(0, (sum, match) => sum + (match.group(1)?.trim().length ?? 0));
      
      if (totalAnswerLength < 10) {
        return {
          "score": 0,
          "summary": "The session was too short for a full analysis. Please speak more during your responses.",
          "metrics": {
            "confidence": "Low",
            "pacing": "N/A",
            "clarity": "Low",
            "eyeContact": "N/A"
          },
          "insights": [
            "No significant audio input was captured.",
            "Ensure you are speaking clearly into the microphone.",
            "Try to provide longer, more detailed answers."
          ]
        };
      }

      final prompt = '''
        You are an expert technical interviewer and career coach.
        
        Analyze the following interview transcript:
        "$userAnswer"

        Evaluate the candidate's performance. 
        Provide a detailed assessment in JSON format with exactly these fields:
        {
          "score": (integer 0-100),
          "summary": (string, concise overview),
          "metrics": {
            "confidence": "High/Medium/Low",
            "pacing": "Fast/Good/Slow",
            "clarity": "High/Medium/Low",
            "eyeContact": "Good/Poor"
          },
          "insights": [
            "insight 1",
            "insight 2",
            "insight 3"
          ]
        }
        
        Return ONLY the raw JSON object. Do not include markdown code blocks (like ```json) or any other text.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final responseText = response.text;
      if (responseText == null || responseText.isEmpty) {
        throw Exception('AI returned an empty response');
      }

      if (kDebugMode) {
        print('AI Raw Response: $responseText');
      }

      // Robust JSON extraction logic
      String cleanedJson = responseText.trim();
      
      // 1. Remove markdown if present
      if (cleanedJson.startsWith('```')) {
        final lines = cleanedJson.split('\n');
        if (lines.length > 2) {
          cleanedJson = lines.sublist(1, lines.length - 1).join('\n');
        }
      }
      
      // 2. Find the first '{' and last '}' to handle stray text
      final start = cleanedJson.indexOf('{');
      final end = cleanedJson.lastIndexOf('}');
      if (start != -1 && end != -1 && end > start) {
        cleanedJson = cleanedJson.substring(start, end + 1);
      }
      
      try {
        return jsonDecode(cleanedJson);
      } catch (e) {
        if (kDebugMode) {
          print('JSON Decode Error: $e. Cleaned String: $cleanedJson');
        }
        // Last ditch attempt: if it's not JSON, try to wrap it if it looks like a summary
        throw Exception('Failed to parse AI response as JSON');
      }
    } catch (e) {
      if (kDebugMode) {
        print('CRITICAL: AI Service Error: $e');
      }
      
      return {
        "score": 0,
        "summary": "AI Analysis could not be completed. Please check your internet connection and API key.",
        "metrics": {
          "confidence": "N/A",
          "pacing": "N/A",
          "clarity": "N/A",
          "eyeContact": "N/A"
        },
        "insights": [
          "Technical Error: $e",
          "This usually happens when the API key is restricted or the transcript is too complex.",
          "Try a shorter session or check the developer console."
        ]
      };
    }
  }
}
