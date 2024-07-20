import 'package:flutter/material.dart';
import 'dart:math';
import 'package:nutricare/AI%20Chatbot/chatbotmain.dart'; // Ensure this import is correct

class Home2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home2Screen(),
      theme: ThemeData(
        primaryColor: Color(0xFF2abca4),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFF2abca4),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
          titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black87),
        ),
      ),
    );
  }
}

class Home2Screen extends StatefulWidget {
  @override
  _Home2ScreenState createState() => _Home2ScreenState();
}

class _Home2ScreenState extends State<Home2Screen> with SingleTickerProviderStateMixin {
  double calorieIntake = 0.0; // Initial calorie intake
  double maxCalories = 2500.0; // Maximum calories for the day (example)
  late AnimationController _animationController;
  final TextEditingController _calorieController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calorieController.dispose();
    super.dispose();
  }

  void updateCalories(double calories) {
    setState(() {
      calorieIntake += calories;
      if (calorieIntake > maxCalories) {
        calorieIntake = maxCalories; // Limit intake to maxCalories
      }
      _animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Adjust padding and spacing based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600; // Example breakpoint for larger screens

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calorie Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF2abca4),
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
                color: Color(0xFF2abca4), // Green color
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
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
                  SizedBox(height: 10.0),
                  Text(
                    'Calories Consumed: ${calorieIntake.toInt()} / ${maxCalories.toInt()}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white) ?? TextStyle(color: Colors.white), // Text color white
                  ),
                  SizedBox(height: 10.0),
                  // TextField for entering calories
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          chatbotmain(); // Call the chatbotmain function directly
        },
        child: Image.asset('assets/robot.png'), // Ensure this path is correct
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