import 'package:flutter/material.dart';
import 'package:nutricare/models/nutritionixfoodmodel.dart';
import 'package:nutricare/nutritionix/nutritionixapi.dart'; // Update this path

class FoodInfoBox extends StatelessWidget {
  final FoodInfo foodInfo;

  const FoodInfoBox({Key? key, required this.foodInfo}) : super(key: key);

  void _fetchAndShowNutritionalInfo(BuildContext context) async {
    // Assuming NutritionixApi has a method getNutritionalInfo that takes foodName
    final nutritionalInfo = await NutritionixApi().getNutritionalInfo(foodInfo.foodName);
    // Display the nutritional info (e.g., in a dialog)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(foodInfo.foodName),
        content: Text('Calories: ${nutritionalInfo.calories}\n'
            'Protein: ${nutritionalInfo.protein}g\n'
            'Fat: ${nutritionalInfo.totalFat}g\n'
            'Carbs: ${nutritionalInfo.totalCarbohydrate}g'),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: GestureDetector(
                onTap: () => _fetchAndShowNutritionalInfo(context),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(foodInfo.photoThumbUrl),
                ),
              ),
              title: Text(
                foodInfo.foodName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text('Tap on image for more info'),
            ),
          ],
        ),
      ),
    );
  }
}