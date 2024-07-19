import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutricare/AI%20Chatbot/chatbotmain.dart';
import 'package:nutricare/AI%20Stuff/camerastream.dart';
import 'package:nutricare/nutritionix/nutrionixsearch.dart';
import 'package:nutricare/nutritionix/nutritionixapi.dart';
import 'package:nutricare/pages/welcomesceen.dart';

class Nutrionixexercise extends StatefulWidget {
  @override
  _NutrionixexerciseState createState() => _NutrionixexerciseState();
}

class _NutrionixexerciseState extends State<Nutrionixexercise> {
  final TextEditingController _controller = TextEditingController();

  void _sendQuery() async {
    String query = _controller.text;
    if (query.isNotEmpty) {
      try {
        var response = await NutritionixApi().fetchExerciseData(query);
        final responseData = jsonDecode(response);
        final double caloriesBurned = responseData['exercises'][0]['nf_calories'];
        _showResponseDialog(caloriesBurned);
      } catch (e) {
        print(e); // Handle the error properly
      }
    }
  }

  void _showResponseDialog(double caloriesBurned) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exercise Data'),
          content: Text('Estimated Calories Burned: $caloriesBurned'),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Enter your exercise'),
            ),
            ElevatedButton(
              onPressed: _sendQuery,
              child: Text('Send'),
            ),
            ElevatedButton(
              onPressed: () {
                chatbotmain();
              },
              child: Text('go to chat bot'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              child: Text('Go to bot'),
            ),
            ElevatedButton(
              onPressed: () {


              },
              child: Text('Go to Camera Test'),
            ),
          ],
        ),
      ),
    );
  }
}