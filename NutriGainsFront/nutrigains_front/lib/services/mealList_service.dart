import 'dart:convert';
import 'dart:ffi';

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

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });
    isLoading = false;
    notifyListeners();

    if (resp.statusCode == 201) {
      final responseData = jsonDecode(resp.body) as List<dynamic>;
      List<MealListModel> mealList = responseData
          .map((item) => MealListModel(
                id: int.tryParse(item['id'].toString()) ?? 0,
                food_id: item['idFood'] != null
                    ? int.tryParse(item['idFood'].toString())
                    : null,
                meal_id: item['idMeal'] != null
                    ? int.tryParse(item['idMeal'].toString())
                    : null,
                recipe_id: item['idRecipe'] != null
                    ? int.tryParse(item['idRecipe'].toString())
                    : null,
              ))
          .toList();
      return mealList;
    } else {
      print('BAD REQUEST - MEAL NOT CREATED');
      print(resp.statusCode);
      throw Exception('Failed to get meal list');
    }
  }

  Future<List<MealListModel>> getmeallistbyidmeal(int id) async {
    final mealListService = MealListService();
    final List<MealListModel> mealList =
        await mealListService.getMealListByIdMeal(id);
    for (var meal in mealList) {
      print('id ${meal.id}');
      print('recipe ${meal.recipe_id}');
      print('food ${meal.food_id}');
      print('meal ${meal.meal_id}');
    }
    return mealList;
  }
}
