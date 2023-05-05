import 'dart:convert';

import 'package:flutter/material.dart';

import 'auth_service.dart';

import 'package:http/http.dart' as http;

class CommentService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.135:8080';
  bool isLoading = true;
  Future newComment(int idRecipe, String comment) async {
    final url = Uri.http(_baseUrl, '/api/user/newcomment/$idRecipe');
    String? token = await AuthService().getToken();

    isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {'comment': comment};

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
      print('OK - COMMENT CREATED');
    } else {
      print('BAD REQUEST - COMMENT NOT CREATED');
      print(resp.statusCode);
    }
  }
}
