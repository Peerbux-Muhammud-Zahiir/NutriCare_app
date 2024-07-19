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
  double getActivityFactor(String activityLevel) {
    switch (activityLevel) {
      case 'Sedentary':
        return 1.2;
      case 'Lightly active':
        return 1.375;
      case 'Moderately active':
        return 1.55;
      case 'Very active':
        return 1.725;
      case 'Extra active':
        return 1.9;
      default:
        return 1.0; // Default if activity level is not recognized
    }
  }

  // Method to calculate TDEE based on BMR and activity factor
  double calculateTDEE(double bmr, String activityLevel) {
    double activityFactor = getActivityFactor(activityLevel);
    return bmr * activityFactor;
  }

  // Method to adjust caloric intake based on goal
  double adjustCaloriesForGoal(double tdee, String goal) {
    switch (goal) {
      case 'Lose Weight':
        return tdee - 500; // Can be adjusted to a range as needed
      case 'Maintain Weight':
        return tdee;
      case 'Gain Muscle':
        return tdee + 250; // Can be adjusted to a range as needed
      default:
        return tdee; // Default to maintain weight if goal is not recognized
    }
  }
}

void main() {
  BMRCalculator bmrCalculator = BMRCalculator();

  // Example data
  double weight = 70.0; // in kg
  double height = 175.0; // in cm
  int age = 25; // in years
  String activityLevel = 'Moderately active';
  String goal = 'Lose Weight';

  // Calculate BMR for a man
  double bmrMen = bmrCalculator.calculateBMRForMen(weight, height, age);
  print('BMR for Men: $bmrMen');

  // Calculate TDEE
  double tdee = bmrCalculator.calculateTDEE(bmrMen, activityLevel);
  print('TDEE: $tdee');

  // Adjust calories for goal
  double adjustedCalories = bmrCalculator.adjustCaloriesForGoal(tdee, goal);
  print('Adjusted Calories for Goal ($goal): $adjustedCalories');
}
