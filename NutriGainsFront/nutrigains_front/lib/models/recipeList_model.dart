// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

class RecipeListModel {
  RecipeListModel({
    required this.id,
    required this.grams,
    required this.idFood,
    required this.idRecipe,
  });

  int id;
  int grams;
  int idFood;
  int idRecipe;

  factory RecipeListModel.fromRawJson(String str) =>
      RecipeListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeListModel.fromJson(Map<String, dynamic> json) =>
      RecipeListModel(
        id: json["id"],
        grams: json["grams"],
        idFood: json["idFood"],
        idRecipe: json["idRecipe"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "grams": grams,
        "idFood": idFood,
        "idRecipe": idRecipe,
      };
}
