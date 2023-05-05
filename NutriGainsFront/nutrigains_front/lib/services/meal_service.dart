import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutrigains_front/models/meal_model.dart';

import 'auth_service.dart';

import 'package:http/http.dart' as http;

class MealService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.135:8080';
  bool isLoading = true;
  Future newMeal() async {
    final url = Uri.http(_baseUrl, '/api/user/newmeal');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    final resp = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });
    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 201) {
      print('OK - MEAL CREATED');
    } else {
      print('BAD REQUEST - MEAL NOT CREATED');
      print(resp.statusCode);
    }
  }

  Future<List<MealModel>> getMealByDate(String date) async {
    final url = Uri.http(_baseUrl, '/api/user/getmealbydate/$date');
    String? token = await AuthService().getToken();
    print(token);
    isLoading = true;
    notifyListeners();
    print(url);

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });

    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 200) {
      final List<dynamic> mealsJson = json.decode(resp.body);
      final List<MealModel> meals =
          mealsJson.map((mealJson) => MealModel.fromJson(mealJson)).toList();
      print(meals);
      return meals;
    } else {
      print(resp.statusCode);
      throw Exception('Failed to load meals');
    }
  }
}
