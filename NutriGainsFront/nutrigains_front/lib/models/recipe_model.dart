// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

class RecipeModel {
  RecipeModel({
    required this.id,
    required this.name,
    required this.user_id,
  });

  Long id;
  String name;
  Long user_id;

  factory RecipeModel.fromRawJson(String str) =>
      RecipeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        id: json["id"],
        name: json["name"],
        user_id: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_id": user_id,
      };
}
