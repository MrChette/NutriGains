import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutrigains_front/models/meal_model.dart';

import 'auth_service.dart';

import 'package:http/http.dart' as http;

class MealService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.135:8080';
  bool isLoading = true;

  Future newFoodMeal(int idFood, int grams) async {
    final url = Uri.http(_baseUrl, '/api/user/newfoodmeal/$idFood/$grams');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    print(token);
    final resp =
        await http.post(url, headers: {"Authorization": "Bearer $token"});

    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 201) {
      final mealResponse = MealModel.fromJson(json.decode(resp.body));
      final mealModel = MealModel(
        id: mealResponse.id,
        user_id: mealResponse.user_id,
        date: DateTime.parse(mealResponse.date).toString(),
      );
      print(mealModel.toString());
      print('OK - FOODMEAL CREATED');
      return mealModel;
    } else {
      print('BAD REQUEST - FOODMEAL NOT CREATED');
      print(resp.statusCode);
    }
  }

  Future newRecipeMeal(int idRecipe) async {
    final url = Uri.http(_baseUrl, '/api/user/newrecipemeal/$idRecipe');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    print(token);
    final resp =
        await http.post(url, headers: {"Authorization": "Bearer $token"});

    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 201) {
      final mealResponse = MealModel.fromJson(json.decode(resp.body));
      final mealModel = MealModel(
        id: mealResponse.id,
        user_id: mealResponse.user_id,
        date: DateTime.parse(mealResponse.date).toString(),
      );
      print(mealModel.toString());
      print('OK - RECIPEMEAL CREATED');
      return mealModel;
    } else {
      print('BAD REQUEST - RECIPEMEAL NOT CREATED');
      print(resp.statusCode);
    }
  }

  Future<MealModel> getMealById(int idmeal) async {
    final url = Uri.http(_baseUrl, '/api/user/getmealbyid/$idmeal');
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

    if (resp.statusCode == 201) {
      final mealsJson = json.decode(resp.body);
      final meals = MealModel.fromJson(mealsJson);
      return meals;
    } else {
      print(resp.statusCode);
      throw Exception('Failed to load meals');
    }
  }

  Future<List<MealModel>> getMealByDate(String date) async {
    final url = Uri.http(_baseUrl, '/api/user/getmealbydate/$date');
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
      final List<dynamic> mealsJson = json.decode(resp.body);
      final List<MealModel> meals =
          mealsJson.map((mealJson) => MealModel.fromJson(mealJson)).toList();
      return meals;
    } else {
      print(resp.statusCode);
      throw Exception('Failed to load meals');
    }
  }
}
