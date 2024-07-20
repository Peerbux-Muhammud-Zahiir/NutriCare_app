import 'package:flutter/material.dart';

class CaloriesProvider with ChangeNotifier {
  double _adjustedCalories = 2500.0; // Default value

  double get adjustedCalories => _adjustedCalories;

  void setAdjustedCalories(double calories) {
    _adjustedCalories = calories;
    notifyListeners();
  }
}