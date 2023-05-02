import 'dart:convert';

import 'package:flutter/material.dart';

import 'auth_service.dart';

import 'package:http/http.dart' as http;

class MealService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.135:8080';
  bool isLoading = true;
  Future newMeal() async {
    final url = Uri.http(_baseUrl, '/api/user/newmeal');
    String? token = await AuthService().readToken();

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
}
