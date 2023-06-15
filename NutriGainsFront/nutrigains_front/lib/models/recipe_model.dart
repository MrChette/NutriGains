// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class RecipeModel {
  RecipeModel(
      {required this.id,
      required this.name,
      required this.user_id,
      required this.kcal,
      required this.protein,
      required this.fat,
      required this.carbohydrates,
      required this.sugar,
      required this.salt});

  int id;
  String name;
  int user_id;
  double kcal;
  double protein;
  double fat;
  double carbohydrates;
  double sugar;
  double salt;

  factory RecipeModel.fromRawJson(String str) =>
      RecipeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        id: json["id"],
        name: json["name"],
        user_id: json["idUser"],
        kcal: json["kcal"],
        protein: json["protein"],
        fat: json["fat"],
        carbohydrates: json["carbohydrates"],
        sugar: json["sugar"],
        salt: json["salt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_id": user_id,
        "kcal": kcal,
        "protein": protein,
        "fat": fat,
        "carbohydrates": carbohydrates,
        "sugar": sugar,
        "salt": salt,
      };

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, user_id: $user_id, kcal: $kcal, protein: $protein, fat: $fat, carbohydrates: $carbohydrates, sugar: $sugar, salt: $salt}';
  }
}
