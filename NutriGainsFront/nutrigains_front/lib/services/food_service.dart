import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nutrigains_front/models/food_model.dart';

import 'auth_service.dart';

import 'package:http/http.dart' as http;

class FoodService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.135:8080';
  bool isLoading = true;
  Future newFood(FoodModel food) async {
    final url = Uri.http(_baseUrl, '/api/user/newfood');
    String? token = await AuthService().readToken();

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

  Future newFoodByBarcode(int barcode) async {
    final url = Uri.http(_baseUrl, '/api/user/foodbyapi/$barcode');
    String? token = await AuthService().readToken();

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
}
