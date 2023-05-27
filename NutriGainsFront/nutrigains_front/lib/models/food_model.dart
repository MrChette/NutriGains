// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

class FoodModel {
  int? id;
  String name;
  int? barcode;
  double? carbohydrates;
  double? fat;
  double? kcal;
  double? protein;
  double? salt;
  double? sugar;

  FoodModel({
    this.id,
    required this.name,
    this.barcode,
    this.carbohydrates,
    this.fat,
    this.kcal,
    this.protein,
    this.salt,
    this.sugar,
  });

  factory FoodModel.withSomeData({
    double carbohydrates = 0.0,
    double fat = 0.0,
    double kcal = 0.0,
    double protein = 0.0,
  }) {
    return FoodModel(
      name: '',
      carbohydrates: carbohydrates,
      fat: fat,
      kcal: kcal,
      protein: protein,
      salt: 0.0, // Valor predeterminado para salt
      sugar: 0.0, // Valor predeterminado para sugar
    );
  }

  factory FoodModel.fromRawJson(String str) =>
      FoodModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        id: json["id"] as int?,
        name: json["name"],
        barcode: json["barcode"] as int?,
        carbohydrates: json["carbohydrates"],
        fat: json["fat"],
        kcal: json["kcal"],
        protein: json["protein"],
        salt: json["salt"],
        sugar: json["sugar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "barcode": barcode,
        "carbohydrates": carbohydrates,
        "fat": fat,
        "kcal": kcal,
        "protein": protein,
        "salt": salt,
        "sugar": sugar,
      };

  @override
  String toString() {
    return 'MealModel(id : $id, name: $name, bacode: $barcode, carbohydrates : $carbohydrates, fat: $fat, kcal: $kcal, protein: $protein, salt: $salt, sugar: $sugar)';
  }
}
