// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

class MealModel {
  int? id;
  String date;
  int? user_id;

  MealModel({
    this.id,
    required this.date,
    this.user_id,
  });

  factory MealModel.fromRawJson(String str) =>
      MealModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
        id: json["id"],
        date: json["date"],
        user_id: json["idUser"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "user_id": user_id,
      };

  @override
  String toString() {
    return 'MealModel(id: $id, date: $date, user_id: $user_id)';
  }
}
