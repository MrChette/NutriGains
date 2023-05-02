import 'dart:convert';

class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.enabled,
    required this.role,
    required this.token,
  });

  int id;
  String username;
  String password;
  bool enabled;
  String role;
  String token;

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        enabled: json["enabled"],
        role: json["role"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "enabled": enabled,
        "role": role,
        "token": token,
      };
}
