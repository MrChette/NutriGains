import 'dart:convert';

class CategoryModel {
    CategoryModel({
        required this.id,
        required this.name,
        required this.description,
    });

    int id;
    String name;
    String description;

    factory CategoryModel.fromJson(String str) => CategoryModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
    };
}