// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class MealModel {
  int? id;
  String date;
  int? user_id;
  int? food_id;
  int? recipe_id;
  int? grams;

  MealModel(
      {this.id,
      required this.date,
      this.user_id,
      this.food_id,
      this.recipe_id,
      this.grams});

  factory MealModel.fromRawJson(String str) =>
      MealModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
      id: json["id"],
      date: json["date"],
      user_id: json["idUser"],
      food_id: json["idFood"],
      recipe_id: json["idRecipe"],
      grams: json["grams"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "user_id": user_id,
        "food_id": food_id,
        "recipe_id": recipe_id,
        "grams": grams,
      };

  @override
  String toString() {
    return 'MealModel(id: $id, date: $date, user_id: $user_id, food_id: $food_id, recipe_id: $recipe_id, grams: $grams)';
  }
}
