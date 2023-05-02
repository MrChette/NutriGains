// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

class MealModel {
  MealModel(
      {required this.id,
      required this.food_id,
      required this.meal_id,
      required this.recipe_id});

  Long id;
  Long food_id;
  Long meal_id;
  Long recipe_id;

  factory MealModel.fromRawJson(String str) =>
      MealModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
        id: json["id"],
        food_id: json["food_id"],
        meal_id: json["meal_id"],
        recipe_id: json["recipe_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "food_id": food_id,
        "meal_id": meal_id,
        "recipe_id": recipe_id,
      };
}
