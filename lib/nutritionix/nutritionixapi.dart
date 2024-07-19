import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nutricare/models/nutritionalinfo.dart';

class NutritionixApi {
  static const String _appId = '5ed94ed6'; // Your actual Application ID
  static const String _apiKey = 'e045d64e7d1a82335a1996fcb474f044'; // Your actual API Key
  static const String _baseUrl = 'https://trackapi.nutritionix.com/v2';

  Future<List<dynamic>> fetchAutocompleteData(String query) async {
    final String url = '$_baseUrl/search/instant/?query=$query';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-app-id': _appId,
          'x-app-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['common'] as List<dynamic>; // Assuming 'common' holds the autocomplete suggestions
      } else {
        print('Error fetching autocomplete data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchNutritionalDetails(String foodName) async {
    final String url = '$_baseUrl/natural/nutrients'; // Assuming this is the correct endpoint
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-app-id': _appId,
          'x-app-key': _apiKey,
        },
        body: jsonEncode({'query': foodName}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // Assuming the API returns a JSON object with the nutritional details
      } else {
        print('Error fetching nutritional details: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }

  Future<NutritionalInfo> getNutritionalInfo(String foodName) async {
    final String url = '$_baseUrl/natural/nutrients';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'x-app-id': _appId,
        'x-app-key': _apiKey,
      },
      body: jsonEncode({'query': foodName}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return NutritionalInfo.fromJson(
          data['foods'][0]); // Assuming the first item in the 'foods' array is the desired one
    } else {
      throw throw Exception('Failed to load nutritional info');
    }
  }
  Future<String> fetchExerciseData(String query) async {
    final String url = '$_baseUrl/natural/exercise';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'x-app-id': _appId,
        'x-app-key': _apiKey,
      },
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch exercise data. Status code: ${response.statusCode}');
    }
  }





}