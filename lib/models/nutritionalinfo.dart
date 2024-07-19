class NutritionalInfo {
  final double calories;
  final double protein;
  final double totalFat;
  final double totalCarbohydrate;
  final double cholesterol; // Added cholesterol property

  NutritionalInfo({
    required this.calories,
    required this.protein,
    required this.totalFat,
    required this.totalCarbohydrate,
    required this.cholesterol, // Include cholesterol in constructor
  });

  factory NutritionalInfo.fromJson(Map<String, dynamic> json) {
    return NutritionalInfo(
      calories: json['nf_calories']?.toDouble() ?? 0.0,
      protein: json['nf_protein']?.toDouble() ?? 0.0,
      totalFat: json['nf_total_fat']?.toDouble() ?? 0.0,
      totalCarbohydrate: json['nf_total_carbohydrate']?.toDouble() ?? 0.0,
      cholesterol: json['nf_cholesterol']?.toDouble() ?? 0.0, // Parse cholesterol from JSON
    );
  }
}