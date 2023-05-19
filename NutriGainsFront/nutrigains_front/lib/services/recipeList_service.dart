import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'auth_service.dart';

class RecipeListService extends ChangeNotifier {
  final String _baseUrl = '192.168.231.208:8080';
  bool isLoading = true;

  Future addFoodToRecipe(int idRecipe, int idFood) async {
    final url = Uri.http(_baseUrl, '/api/user/foodtorecipe/$idRecipe/$idFood');
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
      print('OK - FOOD ADDED TO RECIPE');
    } else {
      print('BAD REQUEST - CANT ADD FOOD TO RECIPE');
      print(resp.statusCode);
    }
  }
}
