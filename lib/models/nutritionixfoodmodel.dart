class FoodInfo {
  final String foodName;
  final double servingQty;
  final String servingUnit;
  final double calories;
  final double totalFat;
  final double saturatedFat;
  final double cholesterol;
  final double sodium;
  final double totalCarbohydrate;
  final double dietaryFiber;
  final double sugars;
  final double protein;
  final double caffeine;
  final String photoThumbUrl;

  FoodInfo({
    required this.foodName,
    required this.servingQty,
    required this.servingUnit,
    required this.calories,
    required this.totalFat,
    required this.saturatedFat,
    required this.cholesterol,
    required this.sodium,
    required this.totalCarbohydrate,
    required this.dietaryFiber,
    required this.sugars,
    required this.protein,
    required this.caffeine,
    required this.photoThumbUrl,
  });

  factory FoodInfo.fromJson(Map<String, dynamic> json) {
    return FoodInfo(
      foodName: json['food_name'] ?? 'Unknown',
      servingQty: (json['serving_qty'] as num?)?.toDouble() ?? 0.0,
      servingUnit: json['serving_unit'] ?? 'Unknown',
      calories: (json['nf_calories'] as num?)?.toDouble() ?? 0.0,
      totalFat: (json['nf_total_fat'] as num?)?.toDouble() ?? 0.0,
      saturatedFat: (json['nf_saturated_fat'] as num?)?.toDouble() ?? 0.0,
      cholesterol: (json['nf_cholesterol'] as num?)?.toDouble() ?? 0.0,
      sodium: (json['nf_sodium'] as num?)?.toDouble() ?? 0.0,
      totalCarbohydrate: (json['nf_total_carbohydrate'] as num?)?.toDouble() ?? 0.0,
      dietaryFiber: (json['nf_dietary_fiber'] as num?)?.toDouble() ?? 0.0,
      sugars: (json['nf_sugars'] as num?)?.toDouble() ?? 0.0,
      protein: (json['nf_protein'] as num?)?.toDouble() ?? 0.0,
      caffeine: (json['nf_caffeine'] as num?)?.toDouble() ?? 0.0, // Assuming caffeine is also a value you're interested in
      photoThumbUrl: json['photo']['thumb'] ?? '',
    );
  }
}