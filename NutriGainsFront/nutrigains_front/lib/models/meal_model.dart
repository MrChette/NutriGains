// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

class MealModel {
  MealModel({
    required this.id,
    required this.date,
    required this.user_id,
  });

  Long id;
  DateTime date;
  Long user_id;

  factory MealModel.fromRawJson(String str) =>
      MealModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
        id: json["id"],
        date: json["date"],
        user_id: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "user_id": user_id,
      };
}
