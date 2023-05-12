import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nutrigains_front/models/food_model.dart';
import 'package:nutrigains_front/models/meal_model.dart';

import 'auth_service.dart';

import 'package:http/http.dart' as http;

class FoodService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.135:8080';
  bool isLoading = true;

  Future newFood(FoodModel food) async {
    final url = Uri.http(_baseUrl, '/api/user/newfood');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {
      "name": food.name,
      "kcal": food.kcal,
      "protein": food.protein,
      "fat": food.fat,
      "carbohydrates": food.carbohydrates,
      "sugar": food.sugar,
      "salt": food.salt
    };

    final encodeFormData = utf8.encode(json.encode(authData));

    final resp = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: encodeFormData);

    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 201) {
      print('OK - FOOD CREATED');
    } else {
      print('BAD REQUEST - RECIPE NOT CREATED');
      print(resp.statusCode);
    }
  }

  Future newFoodByApi(int barcode) async {
    final url = Uri.http(_baseUrl, '/api/user/foodbyapi/$barcode');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });

    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 200) {
      print('OK - FOOD BY BARCODE CREATED');
    } else {
      print('BAD REQUEST - FOOD BY BARCODE NOT CREATED');
      print(resp.statusCode);
    }
  }

  Future findFoodinBbdd(int barcode) async {
    final url = Uri.http(_baseUrl, '/api/user/getfoodbybarcode/$barcode');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });

    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 200) {
      final Map<String, dynamic> foodJson = json.decode(resp.body);
      final FoodModel food = FoodModel.fromJson(foodJson);
      print('OK - FOOD FOUND IN BBDD');
      return food;
    } else if (resp.statusCode == 204) {
      print('FOOD NOT FOUND IN BBDD - REQUEST TO EXTERNAL API');
      print(resp.statusCode);
      return null;
    } else {
      print("ERROR");
      print(resp.statusCode);
    }
  }

  Future getAllUserFood() async {
    final url = Uri.http(_baseUrl, '/api/user/getalluserfood');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });

    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 200) {
      final List<dynamic> foodsJson = json.decode(resp.body);
      final List<FoodModel> food =
          foodsJson.map((foodJson) => FoodModel.fromJson(foodJson)).toList();
      return food;
    } else {
      print(resp.statusCode);
      throw Exception('Failed to load foods');
    }
  }
}
