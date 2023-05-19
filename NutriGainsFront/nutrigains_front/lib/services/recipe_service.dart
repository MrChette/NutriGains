import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/recipeList_model.dart';
import '../models/recipe_model.dart';
import 'auth_service.dart';

import 'package:http/http.dart' as http;

class RecipeService extends ChangeNotifier {
  final String _baseUrl = '192.168.231.208:8080';
  bool isLoading = true;
  Future newRecipe(String name) async {
    final url = Uri.http(_baseUrl, '/api/user/newrecipe');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {'name': name};

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
      print('OK - RECIPE CREATED');
    } else {
      print('BAD REQUEST - RECIPE NOT CREATED');
      print(resp.statusCode);
    }
  }

  Future getalluserrecipe() async {
    final url = Uri.http(_baseUrl, '/api/user/getalluserrecipe');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });
    List<dynamic> recipeJsonList = [];
    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 200) {
      recipeJsonList = jsonDecode(resp.body);
      final List<RecipeModel> recipes =
          recipeJsonList.map((json) => RecipeModel.fromJson(json)).toList();
      print('OK - RECIPES RECEIVED');
      return recipes;
    } else {
      print('BAD REQUEST - RECIPES NOT RECEIVED');
      print(resp.statusCode);
      return recipeJsonList;
    }
  }

  Future getRecipe(int id) async {
    final url = Uri.http(_baseUrl, '/api/user/getrecipe/$id');
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
    if (resp.statusCode == 202) {
      final recipeJson = jsonDecode(resp.body);
      final recipe = RecipeModel.fromJson(recipeJson);
      print('OK - RECIPE RECIBED $recipe');
      return recipe;
    } else {
      print('BAD REQUEST - RECIPE NOT RECIBED');
      print(resp.statusCode);
    }
  }
}
