import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/mealList_model.dart';
import 'auth_service.dart';

import 'package:http/http.dart' as http;

class MealListService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.135:8080';
  bool isLoading = true;

  Future<List<MealListModel>> getMealListByIdMeal(int id) async {
    final url = Uri.http(_baseUrl, '/api/user/getmeallistbyidmeal/$id');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    final resp =
        await http.get(url, headers: {"Authorization": "Bearer $token"});
    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 201) {
      final List<dynamic> mealsJson = json.decode(resp.body);
      final List<MealListModel> meals = mealsJson
          .map((mealsJson) => MealListModel.fromJson(mealsJson))
          .toList();
      return meals;
    } else {
      print('BAD REQUEST - MEAL NOT CREATED');
      print(resp.statusCode);
      throw Exception('Failed to get meal list');
    }
  }

  Future addFoodToMeal(int? idMeal, int idFood) async {
    final url = Uri.http(_baseUrl, '/api/user/foodtomeal/$idMeal/$idFood');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    print(token);
    final resp =
        await http.post(url, headers: {"Authorization": "Bearer $token"});

    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 201) {
      print('OK - FOOD ADDED TO MEAL');
    } else {
      print('BAD REQUEST - CANT ADD THE FOOD TO MEAL');
      print(resp.statusCode);
    }
  }

  Future addRecipeToMeal(int? idMeal, int idRecipe) async {
    final url = Uri.http(_baseUrl, '/api/user/recipetomeal/$idMeal/$idRecipe');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    print(token);
    final resp =
        await http.post(url, headers: {"Authorization": "Bearer $token"});

    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 201) {
      print('OK - RECIPE ADDED TO MEAL');
    } else {
      print('BAD REQUEST - CANT ADD THE RECIPE TO MEAL');
      print(resp.statusCode);
    }
  }
}
