// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

class FoodModel {
  String name;
  Long? barcode;
  double carbohydrates;
  double fat;
  double kcal;
  double protein;
  double salt;
  double sugar;

  FoodModel({
    required this.name,
    this.barcode,
    required this.carbohydrates,
    required this.fat,
    required this.kcal,
    required this.protein,
    required this.salt,
    required this.sugar,
  });

  factory FoodModel.fromRawJson(String str) =>
      FoodModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        name: json["name"],
        barcode: json["barcode"],
        carbohydrates: json["carbohydrates"],
        fat: json["fat"],
        kcal: json["kcal"],
        protein: json["protein"],
        salt: json["salt"],
        sugar: json["sugar"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "barcode": barcode,
        "carbohydrates": carbohydrates,
        "fat": fat,
        "kcal": kcal,
        "protein": protein,
        "salt": salt,
        "sugar": sugar,
      };
}
