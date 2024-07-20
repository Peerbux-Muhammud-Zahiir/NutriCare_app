import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutricare/models/usermodel.dart';
import 'package:nutricare/firebasestuff/authentication.dart';
import 'package:nutricare/randomutilities/calories_provider.dart';
import 'package:provider/provider.dart';

Future<UserModel?> getCurrentUserDetails() async {
  Authentication auth = Authentication();
  return await auth.getUserDetails();
}

class SelectedOptions {
  final int selectedOption1;
  final int selectedOption2;

  SelectedOptions(this.selectedOption1, this.selectedOption2);
}

class BMRCalculator {
  // Method to calculate BMR for men
  double calculateBMRForMen(double weight, double height, int age) {
    return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
  }

  // Method to calculate BMR for women
  double calculateBMRForWomen(double weight, double height, int age) {
    return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
  }

  // Method to calculate BMR for children (10–18 years)
  double calculateBMRForChildren(double weight) {
    return (17.686 * weight) + 658.2;
  }

  // Method to calculate BMR for elderly men (over 60 years)
  double calculateBMRForElderlyMen(double weight) {
    return 13.5 * weight + 487;
  }

  // Method to calculate BMR for elderly women (over 60 years)
  double calculateBMRForElderlyWomen(double weight) {
    return 10.5 * weight + 596;
  }

  // Method to calculate BMR for pregnant women
  double calculateBMRForPregnantWomen(double bmr) {
    return bmr + 300; // You can adjust the range (300 to 500) as needed
  }

  // Method to calculate BMR for athletes
  double calculateBMRForAthletes(double bmr, double activityFactor) {
    return bmr * activityFactor;
  }

  // Method to get activity factor
  double getActivityFactor(int activityLevel) {
    switch (activityLevel) {
      case 1:
        return 1.2;
      case 2:
        return 1.375;
      case 3:
        return 1.55;
      case 4:
        return 1.725;
      case 5:
        return 1.9;
      default:
        return 1.0; // Default if activity level is not recognized
    }
  }

  // Method to calculate TDEE based on BMR and activity factor
  double calculateTDEE(double bmr, int activityLevel) {
    double activityFactor = getActivityFactor(activityLevel);
    return bmr * activityFactor;
  }

  // Method to adjust caloric intake based on goal
  double adjustCaloriesForGoal(double tdee, int goal) {
    switch (goal) {
      case 1:
        return tdee + 250; // Gain
      case 2:
        return tdee; // Maintain
      case 3:
        return tdee - 500; // Lose
      default:
        return tdee; // Default to maintain weight if goal is not recognized
    }
  }
}
void calculateDiet(SelectedOptions options) async {
  UserModel? user = await getCurrentUserDetails();
  if (user != null) {
    print('User Details:');
    print('Username: ${user.username}');
    print('Email: ${user.email}');
    print('Weight: ${user.weight}');
    print('Height: ${user.height}');
    print('Age: ${user.age}');
    print('Gender: ${user.gender}');

    double BMR;
    if (user.age >= 10 && user.age <= 18) {
      BMR = 17.686 * user.weight + 658.2;
    } else if (user.age > 60 && user.gender == 'M') {
      BMR = 13.5 * user.weight + 487;
    } else if (user.age > 60 && user.gender == 'F') {
      BMR = 10.5 * user.weight + 596;
    } else if (user.gender == 'M') {
      BMR = 88.362 + (13.397 * user.weight) + (4.799 * user.height) - (5.677 * user.age);
    } else {
      BMR = 447.593 + (9.247 * user.weight) + (3.098 * user.height) - (4.330 * user.age);
    }
    print('BMR: $BMR');

    BMRCalculator bmrCalculator = BMRCalculator();
    double tdee = bmrCalculator.calculateTDEE(BMR, options.selectedOption2);
    double adjustedCalories = bmrCalculator.adjustCaloriesForGoal(tdee, options.selectedOption1);
    print('TDEE: $tdee');
    print('Adjusted Calories for Goal: $adjustedCalories');
  } else {
    print('No user is currently logged in.');
  }
}

void calculateDietWithContext(SelectedOptions options, BuildContext context) async {
  UserModel? user = await getCurrentUserDetails();
  if (user != null) {
    print('User Details:');
    print('Username: ${user.username}');
    print('Email: ${user.email}');
    print('Weight: ${user.weight}');
    print('Height: ${user.height}');
    print('Age: ${user.age}');
    print('Gender: ${user.gender}');

    double BMR;
    if (user.age >= 10 && user.age <= 18) {
      BMR = 17.686 * user.weight + 658.2;
    } else if (user.age > 60 && user.gender == 'M') {
      BMR = 13.5 * user.weight + 487;
    } else if (user.age > 60 && user.gender == 'F') {
      BMR = 10.5 * user.weight + 596;
    } else if (user.gender == 'M') {
      BMR = 88.362 + (13.397 * user.weight) + (4.799 * user.height) - (5.677 * user.age);
    } else {
      BMR = 447.593 + (9.247 * user.weight) + (3.098 * user.height) - (4.330 * user.age);
    }
    print('BMR: $BMR');

    BMRCalculator bmrCalculator = BMRCalculator();
    double tdee = bmrCalculator.calculateTDEE(BMR, options.selectedOption2);
    double adjustedCalories = bmrCalculator.adjustCaloriesForGoal(tdee, options.selectedOption1);
    print('TDEE: $tdee');
    print('Adjusted Calories for Goal: $adjustedCalories');

    Provider.of<CaloriesProvider>(context, listen: false).setAdjustedCalories(adjustedCalories);
  } else {
    print('No user is currently logged in.');
  }
}