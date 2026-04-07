import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/resource_model.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // We use the universally stable JSONPlaceholder API to prove REST GET competency 
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Fetches structured list of tech interview resources
  Future<List<ResourceModel>> fetchResources() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/posts')).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Step 1: Decode raw string back into a dynamic list payload
        List<dynamic> jsonList = jsonDecode(response.body);

        // Step 2: Slice to top 15 results for performance
        final trimmedList = jsonList.take(15).toList();

        // Step 3: Iterate through objects mapping strictly to ResourceModel DTOs
        return trimmedList.map((json) => ResourceModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load resources: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API Fetch Error: $e');
      throw Exception('Unable to reach REST server. Please check connection and try again.');
    }
  }
}
