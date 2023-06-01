import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../widgets/ip.dart';
import 'auth_service.dart';
import 'package:http/http.dart' as http;

class RecipeService extends ChangeNotifier {
  final String _baseUrl = '${getIp().ip}:8080';
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

  Future<String> deleteRecipe(int idRecipe) async {
    final url = Uri.http(_baseUrl, '/api/user/deleterecipe/$idRecipe');
    String? token = await AuthService().getToken();

    final resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 201) {
      return ('RECIPED DELETED');
    } else {
      return ('Oops, somethin went wrong');
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
      print('getalluserrecipe BAD REQUEST - RECIPES NOT RECEIVED');
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
      print(' getRecipe BAD REQUEST - RECIPE NOT RECIBED');
      print(resp.statusCode);
    }
  }

  Future<List<RecipeModel>> getRecipes(List<int> idMeals) async {
    final List<String> idMealStrings =
        idMeals.map((id) => id.toString()).toList();
    final url = Uri.http(
        _baseUrl, '/api/user/getrecipelist', {'idmeal': idMealStrings});
    String? token = await AuthService().getToken();

    final stopwatch = Stopwatch(); // Crear una instancia de Stopwatch
    stopwatch.start(); //

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    stopwatch.stop(); // Detener el cronómetro
    print('Tiempo de ejecución: ${stopwatch.elapsedMilliseconds} ms');

    if (resp.statusCode == 202) {
      final List<dynamic> recipeJsonList = jsonDecode(resp.body);
      final List<RecipeModel> recipes =
          recipeJsonList.map((json) => RecipeModel.fromJson(json)).toList();
      print('OK - RECIPES RECEIVED');
      return recipes;
    } else {
      List<RecipeModel> recipes = [];
      print('getRecipes BAD REQUEST - RECIPES NOT RECEIVED');
      print(resp.statusCode);
      return recipes;
    }
  }

  Future<List<RecipeModel>> getAllRecipes() async {
    final url = Uri.http(_baseUrl, '/api/user/getallrecipes');
    String? token = await AuthService().getToken();

    final stopwatch = Stopwatch(); // Crear una instancia de Stopwatch
    stopwatch.start(); //

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    stopwatch.stop(); // Detener el cronómetro
    print('Tiempo de ejecución: ${stopwatch.elapsedMilliseconds} ms');

    if (resp.statusCode == 200) {
      final List<dynamic> recipeJsonList = jsonDecode(resp.body);
      final List<RecipeModel> recipes =
          recipeJsonList.map((json) => RecipeModel.fromJson(json)).toList();
      print(recipes);
      print('OK - ALL RECIPES RECEIVED');
      return recipes;
    } else {
      List<RecipeModel> recipes = [];
      print('BAD REQUEST - RECIPES NOT RECEIVED');
      print(resp.statusCode);
      return recipes;
    }
  }

  Future<String> addexternalRecipe(int idRecipe) async {
    final url = Uri.http(_baseUrl, '/api/user/externalrecipe/$idRecipe');
    String? token = await AuthService().getToken();

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (resp.statusCode == 200) {
      return 'RECIPE ADDED TO OWN RECIPES';
    } else {
      print('BAD REQUEST - RECIPES NOT ADDED TO OWN TECIPES NOT RECEIVED');
      print(resp.statusCode);
      return 'Looks like you already have this recipe';
    }
  }
}
