import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutricare/AI%20Stuff/camerastream.dart';
import 'package:nutricare/AI%20Stuff/imagefoodclassification.dart';
import 'package:nutricare/nutritionix/nutrionixsearch.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _result = '';
  String _imageUrl = '';
  Uint8List? _imageBytes;
  final FoodClassification _foodClassification = FoodClassification();

  void _showChatbotDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chatbot'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hello! How can I help you?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _onItemSelected(String name, double calories, double cholesterol, String imageUrl) {
    setState(() {
      _result = 'Food: $name\nCalories: $calories';
      _imageUrl = imageUrl;
    });
  }

  void _onFoodDetected(String label, String calories, Uint8List imageBytes) {
    setState(() {
      _result = 'Food: $label\nCalories: $calories';
      _imageBytes = imageBytes;
    });
  }

  Future<void> _classifyImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final result = await _foodClassification.classifyImageFromSource(image);
      if (result?.containsKey('error') ?? false) {
        // Handle error
        print(result?['error']);
      } else {
        final label = result?['label'] ?? 'Unknown';
        final calories = result?['calories'] ?? 'Unknown';
        final imageBytes = result?['imageBytes'] as Uint8List?;
        if (imageBytes != null) {
          _onFoodDetected(label, calories, imageBytes);
        }
      }
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Run Camera'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraStream(onFoodDetected: _onFoodDetected),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.upload),
              title: Text('Upload Image'),
              onTap: () {
                Navigator.pop(context);
                _classifyImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search Nutritionix'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NutritionixSearch(onItemSelected: _onItemSelected),
                  ),
                );
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
        title: const Text('NutriCare'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showChatbotDialog(context);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Food eaten today:',
              style: TextStyle(
                color: Color(0xFF2abca4),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_imageUrl.isNotEmpty)
                  Image.network(_imageUrl, height: 100, width: 100),
                if (_imageBytes != null)
                  Image.memory(_imageBytes!, height: 100, width: 100),
                Text(_result, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: () {
                _showContextMenu(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}