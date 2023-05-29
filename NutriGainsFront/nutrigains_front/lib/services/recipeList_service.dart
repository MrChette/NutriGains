import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/ip.dart';
import 'auth_service.dart';

class RecipeListService extends ChangeNotifier {
  final String _baseUrl = '${getIp().ip}:8080';
  bool isLoading = true;

  Future<String> foodtorecipe(
      List<int> idFoods, List<int> gramsList, String name) async {
    final url = Uri.http(_baseUrl, '/api/user/foodtorecipe');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

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
    isLoading = false;
    notifyListeners();
    if (resp.statusCode == 201) {
      return ('RECIPE CREATED SUCCESFULY');
    } else {
      return ('Opps, something wrong happened');
    }
  }
}
