import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Nutritionix extends StatefulWidget {
  const Nutritionix({Key? key}) : super(key: key);

  @override
  _NutritionixState createState() => _NutritionixState();
}

class _NutritionixState extends State<Nutritionix> {
  String _responseBody = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const String appId = '5ed94ed6'; // Replace with your actual Application ID
    const String apiKey = 'e045d64e7d1a82335a1996fcb474f044'; // Replace with your actual API Key
    const String url = 'https://trackapi.nutritionix.com/v2/natural/nutrients';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-app-id': appId,
          'x-app-key': apiKey,
        },
        body: jsonEncode({'query': 'grape'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _responseBody = response.body;
        });
      } else {
        setState(() {
          _responseBody = 'Error fetching data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseBody = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutritionix API Test'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_responseBody),
        ),
      ),
    );
  }
}