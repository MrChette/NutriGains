// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class CommentModel {
  CommentModel({
    this.id,
    required this.comment,
    required this.recipe_id,
    this.user_id,
  });

  int? id;
  String comment;
  int recipe_id;
  int? user_id;

  factory CommentModel.fromRawJson(String str) =>
      CommentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        comment: json["comment"],
        recipe_id: json["idRecipe"],
        user_id: json["idUser"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "recipe_id": recipe_id,
        "user_id": user_id,
      };

  @override
  String toString() {
    return 'MealModel(id : $id, comment: $comment, recipe_id: $recipe_id, user_id : $user_id)';
  }
}
