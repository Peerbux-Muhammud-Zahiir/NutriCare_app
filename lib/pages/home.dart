import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutricare/AI%20Chatbot/chatbotmain.dart';
import 'package:nutricare/AI%20Stuff/camerastream.dart';
import 'package:nutricare/AI%20Stuff/imagefoodclassification.dart';
import 'package:nutricare/nutritionix/nutrionixsearch.dart';
import 'package:nutricare/firebasestuff/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutricare/randomutilities/calories_provider.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _foodList = [];
  bool _isUploading = false;
  bool _isProcessing = false;
  final FoodClassification _foodClassification = FoodClassification();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late double calorieIntake; // Initial calorie intake
  double maxCalories = 2500.0; // Maximum calories for the day (example)
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    calorieIntake = 0.0; // Initialize calorieIntake
    _loadFoodList();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _calculateTotalCalories() {
    double totalCalories = 0.0;
    for (var food in _foodList) {
      totalCalories += double.tryParse(food['calories'].toString()) ?? 0.0;
    }
    setState(() {
      calorieIntake = totalCalories;
      _animationController.forward(from: 0.0); // Trigger animation
    });
  }





  void updateCalories(double calories) {
    setState(() {
      calorieIntake += calories;
      if (calorieIntake > maxCalories) {
        calorieIntake = maxCalories; // Limit intake to maxCalories
      }
      _animationController.forward(from: 0.0); // Trigger animation
    });
    _calculateTotalCalories();
  }

  Future<void> _loadFoodList() async {
    String uid = _auth.currentUser!.uid;
    QuerySnapshot snapshot = await _firestore.collection('foods').where('uid', isEqualTo: uid).get();
    setState(() {
      _foodList = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((food) => !food['name'].contains('Calorie') && !food['name'].contains('detected'))
          .toList();
      _calculateTotalCalories(); // Recalculate total calories after loading the food list
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
    _calculateTotalCalories();
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
              leading: const Icon(Icons.camera),
              title: const Text('Run Camera'),
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
              leading: const Icon(Icons.upload),
              title: const Text('Upload Image'),
              onTap: () {
                Navigator.pop(context);
                _classifyImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Nutritionix'),
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
      bool isLargeScreen = MediaQuery.of(context).size.width > 600;
      double maxCalories = Provider.of<CaloriesProvider>(context).adjustedCalories;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calorie Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2abca4),
      ),
      body: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 20.0 : 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                // Enlarged picture
                Container(
                  width: isLargeScreen ? 350 : 250, // Adjust width based on screen size
                  height: isLargeScreen ? 350 : 250, // Adjust height based on screen size
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      "assets/healthy.png", // Ensure this path is correct
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: isLargeScreen ? 30.0 : 10.0),
                // Radial progress
                Expanded(
                  child: RadialProgress(
                    height: isLargeScreen ? 180.0 : 150.0,
                    width: isLargeScreen ? 180.0 : 150.0,
                    progress: calorieIntake / maxCalories,
                    animationController: _animationController,
                  ),
                ),
              ],
            ),
            SizedBox(height: isLargeScreen ? 30.0 : 20.0),
            // Calorie input box
            Container(
              padding: EdgeInsets.all(isLargeScreen ? 20.0 : 10.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2abca4), // Green color
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Today\'s Progress',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Calories Consumed: ${calorieIntake.toInt()} / ${maxCalories.toInt()}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white), // Text color white
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  chatbotmain(); // Call the chatbotmain function directly
                },
                child: Image.asset('assets/robot.png'), // Ensure this path is correct
              ),
            ),
            Expanded(
              child: Stack(
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
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                        title: Text(food['name']),
                        subtitle: Text('Calories: ${food['calories']}'),
                      );
                    },
                  ),
                  if (_isUploading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ],
        ),
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

class RadialProgress extends StatelessWidget {
  final double height;
  final double width;
  final double progress;
  final AnimationController animationController;

  const RadialProgress({
    Key? key,
    required this.height,
    required this.width,
    required this.progress,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: RadialPainter(progress: progress * animationController.value),
          size: Size(width, height),
        );
      },
    );
  }
}

class RadialPainter extends CustomPainter {
  final double progress;

  RadialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    Paint progressPaint = Paint()
      ..color = Color(0xFF2abca4) // Green color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, backgroundPaint);

    double angle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, angle, false, progressPaint);

    // Draw percentage text
    double percentage = (progress * 100).toInt().toDouble();
    TextSpan span = TextSpan(
      style: TextStyle(color: Color(0xFF2abca4), fontSize: 24.0, fontWeight: FontWeight.bold), // Green color
      text: '${percentage.toInt()}%',
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}