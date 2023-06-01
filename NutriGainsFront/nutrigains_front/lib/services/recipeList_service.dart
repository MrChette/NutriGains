import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipeList_model.dart';
import '../widgets/ip.dart';
import 'auth_service.dart';

class RecipeListService extends ChangeNotifier {
  final String _baseUrl = '${getIp().ip}:8080';
  bool isLoading = true;

  Future<String> foodtorecipe(
      List<int> idFoods, List<int> gramsList, String name) async {
    final url = Uri.http(_baseUrl, '/api/user/foodtorecipe');
    String? token = await AuthService().getToken();

    final body = {
      'idFood': idFoods.map((id) => id.toString()).toList(),
      'grams': gramsList.map((grams) => grams.toString()).toList(),
      'name': name,
    };

    final encodeFormData = utf8.encode(json.encode(body));

    final resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: encodeFormData,
    );

    if (resp.statusCode == 201) {
      return ('RECIPE CREATED SUCCESFULY');
    } else {
      return ('Opps, something wrong happened');
    }
  }

  Future<List<RecipeListModel>> getRecipesByIds(idRecipe) async {
    final url = Uri.http(_baseUrl, '/api/user/getrecipesbyids',
        {'idRecipe': idRecipe.join(',')});

    print(idRecipe);

    String? token = await AuthService().getToken();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      print('ok');
      final jsonResponse = json.decode(response.body);
      return List<RecipeListModel>.from(
          jsonResponse.map((data) => RecipeListModel.fromJson(data)));
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch recipes');
    }
  }
}
