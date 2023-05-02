// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

class RecipeModel {
  RecipeModel({
    required this.id,
    required this.food_id,
    required this.recipe_id,
  });

  Long id;
  Long food_id;
  Long recipe_id;

  factory RecipeModel.fromRawJson(String str) =>
      RecipeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        id: json["id"],
        food_id: json["food_id"],
        recipe_id: json["recipe_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "food_id": food_id,
        "recipe_id": recipe_id,
      };
}
