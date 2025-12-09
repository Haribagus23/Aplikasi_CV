import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../models/rating_model.dart';

class RatingService {
  static Future<bool> submitRating({
    required String nama,
    required int rating,
    required String saran,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.ratingsEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'nama': nama, 'rating': rating, 'saran': saran}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint('Failed to submit rating: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error submitting rating: $e');
      return false;
    }
  }

  static Future<List<Rating>> getRatings() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.ratingsEndpoint),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        List<dynamic> list = [];

        if (data is List) {
          list = data;
        } else if (data is Map && data.containsKey('data')) {
          list = data['data'];
        }

        return list.map((json) => Rating.fromJson(json)).toList();
      } else {
        debugPrint('Failed to load ratings: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('Error loading ratings: $e');
      return [];
    }
  }
}
