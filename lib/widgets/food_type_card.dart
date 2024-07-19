import 'package:flutter/material.dart';

class FoodTypeCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isSelected;
  final Function onPress;
  final double imageSize;

  const FoodTypeCard({
    Key? key,
    required this.image,
    required this.title,
    required this.isSelected,
    required this.onPress,
    required this.imageSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueGrey: Colors.green[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 18.0,
              top: 18.0,
              child: isSelected
                  ? Icon(
                Icons.check_circle_outline,
                color: Colors.green[400],
              )
                  : SizedBox.shrink(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(image),),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
