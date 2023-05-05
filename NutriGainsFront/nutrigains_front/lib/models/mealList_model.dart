// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

class MealListModel {
  MealListModel({required this.id, this.food_id, this.meal_id, this.recipe_id});

  int id;
  int? food_id;
  int? meal_id;
  int? recipe_id;

  factory MealListModel.fromRawJson(String str) =>
      MealListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MealListModel.fromJson(Map<String, dynamic> json) => MealListModel(
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
