import 'package:flutter/material.dart';

class FruitWidget extends StatefulWidget {
  const FruitWidget({Key? key}) : super(key: key);

  @override
  _FruitWidgetState createState() => _FruitWidgetState();
}

class _FruitWidgetState extends State<FruitWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(_controller.value),
                borderRadius: BorderRadius.circular(8),
              ),
            );
          },
        ),
        Image.asset(
          'assets/fruit.png', // Replace with the path to your fruit image
          width: 80,
          height: 80,
        ),
      ],
    );
  }
}