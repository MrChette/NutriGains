// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:convert';

class onlyNutriment {
  double carbohydrates;
  double fat;
  double kcal;
  double protein;

  onlyNutriment({
    required this.carbohydrates,
    required this.fat,
    required this.kcal,
    required this.protein,
  });

  factory onlyNutriment.fromRawJson(String str) =>
      onlyNutriment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory onlyNutriment.fromJson(Map<String, dynamic> json) => onlyNutriment(
        carbohydrates: json["carbohydrates"],
        fat: json["fat"],
        kcal: json["kcal"],
        protein: json["protein"],
      );

  Map<String, dynamic> toJson() => {
        "carbohydrates": carbohydrates,
        "fat": fat,
        "kcal": kcal,
        "protein": protein,
      };

  @override
  String toString() {
    return 'MealModel(carbohydrates : $carbohydrates, fat: $fat, kcal: $kcal, protein: $protein)';
  }
}
