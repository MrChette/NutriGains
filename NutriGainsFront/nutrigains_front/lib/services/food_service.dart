import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nutrigains_front/models/food_model.dart';
import 'package:nutrigains_front/models/meal_model.dart';
import 'package:nutrigains_front/models/recipeList_model.dart';

import '../widgets/ip.dart';
import 'auth_service.dart';

import 'package:http/http.dart' as http;

class FoodService extends ChangeNotifier {
  final String _baseUrl = '${getIp().ip}:8080';
  bool isLoading = true;

  Future<String> newFood(FoodModel food) async {
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
      return ('FOOD CREATED SUCCESFULY');
    } else {
      return ('Opps, something wrong happened');
    }
  }

  Future<String> newFoodByApi(int barcode) async {
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
      return 'FOOD ADDED';
    } else {
      return 'Opps, something wrong happened';
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
      final List<FoodModel> food = [];
      return food;
    }
  }

  Future<FoodModel> getFood(int idfood) async {
    final url = Uri.http(_baseUrl, '/api/user/getfood/$idfood');
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
      final dynamic foodJson = json.decode(resp.body);
      final FoodModel food = FoodModel.fromJson(foodJson);
      return food;
    } else {
      final FoodModel food = FoodModel();
      return food;
    }
  }

  Future<List<RecipeListModel>> getFoodsByIdRecipe(int idRecipe) async {
    final url = Uri.http(_baseUrl, '/api/user/getfoodsbyidrecipe/$idRecipe');

    String? token = await AuthService().getToken();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return List<RecipeListModel>.from(
          jsonResponse.map((data) => RecipeListModel.fromJson(data)));
    } else {
      List<RecipeListModel> emptyRecipe = [];
      print('error getfooodsbyidrecipe ${response.statusCode}');
      return emptyRecipe;
    }
  }

  Future<FoodModel> getFoodById(int idFood) async {
    final url = Uri.http(_baseUrl, '/api/user/getfoodbyid/$idFood');

    String? token = await AuthService().getToken();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return FoodModel.fromJson(jsonResponse);
    } else {
      print('error getfoodbyid ${response.statusCode}');
      throw Exception('Failed to fetch food');
    }
  }

  Future<List<FoodModel>> getFoodsByIds(List<int> idFood) async {
    print(idFood);
    final url = Uri.http(
        _baseUrl, '/api/user/getfoodsbyids', {'ids': idFood.join(',')});

    String? token = await AuthService().getToken();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      print('ok');
      final jsonResponse = json.decode(response.body);
      return List<FoodModel>.from(
          jsonResponse.map((data) => FoodModel.fromJson(data)));
    } else {
      print('error getfoodsbyids ${response.statusCode}');
      throw Exception('Failed to fetch recipes');
    }
  }
}
