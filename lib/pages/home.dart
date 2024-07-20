import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutricare/AI%20Stuff/camerastream.dart';
import 'package:nutricare/AI%20Stuff/imagefoodclassification.dart';
import 'package:nutricare/nutritionix/nutrionixsearch.dart';
import 'package:nutricare/firebasestuff/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _foodList = [];
  bool _isUploading = false;
  bool _isProcessing = false;
  final FoodClassification _foodClassification = FoodClassification();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadFoodList();
  }

  Future<void> _loadFoodList() async {
    String uid = _auth.currentUser!.uid;
    QuerySnapshot snapshot = await _firestore.collection('foods').where('uid', isEqualTo: uid).get();
    setState(() {
      _foodList = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((food) => !food['name'].contains('Calorie') && !food['name'].contains('detected'))
          .toList();
    });
  }

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
    if (!name.contains('Calorie') && !name.contains('detected')) {
      setState(() {
        _foodList.add({
          'name': name,
          'calories': calories,
          'imageUrl': imageUrl,
        });
      });
    }
  }

  void _onFoodDetected(String label, String calories, Uint8List imageBytes) async {
    if (label.contains('Calorie') || label.contains('detected') || _isProcessing) {
      return;
    }

    setState(() {
      _isUploading = true;
      _isProcessing = true;
    });

    // Upload image to Firebase Storage
    String imageUrl = await _storageMethods.uploadImageToStorage('foodImages', imageBytes);

    // Save food details to Firestore
    String uid = _auth.currentUser!.uid;
    await _firestore.collection('foods').add({
      'uid': uid,
      'name': label,
      'calories': calories,
      'imageUrl': imageUrl,
    });

    // Update local list
    setState(() {
      _foodList.add({
        'name': label,
        'calories': calories,
        'imageUrl': imageUrl,
      });
      _isUploading = false;
      _isProcessing = false;
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
          ListView.builder(
            itemCount: _foodList.length,
            itemBuilder: (context, index) {
              var food = _foodList[index];
              return ListTile(
                leading: Image.network(
                  food['imageUrl'],
                  height: 50,
                  width: 50,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                title: Text(food['name']),
                subtitle: Text('Calories: ${food['calories']}'),
              );
            },
          ),
          if (_isUploading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContextMenu(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}