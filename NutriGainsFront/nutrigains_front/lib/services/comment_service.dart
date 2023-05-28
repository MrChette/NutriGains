import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutrigains_front/models/comment_model.dart';

import '../models/recipe_model.dart';
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

  Future commentByIdRecipe(int idRecipe) async {
    final url = Uri.http(_baseUrl, '/api/user/commentbyidrecipe/$idRecipe');
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
      final List<dynamic> commentsJson = json.decode(resp.body);
      final List<CommentModel> comment = commentsJson
          .map((commentJson) => CommentModel.fromJson(commentJson))
          .toList();
      print('OK - LISTA COMMENTS');
      return comment;
    } else {
      print('BAD REQUEST - CANT LIST COMMENTS');
      print(resp.statusCode);
    }
  }

  Future getAllComments() async {
    final url = Uri.http(_baseUrl, '/api/user/comments');
    String? token = await AuthService().getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List<CommentModel> comments = parseComments(response.body);
      print(comments);
      return comments;
    } else {
      List<CommentModel> noComments = [];
      return noComments;
    }
  }

  List<CommentModel> parseComments(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CommentModel>((json) => CommentModel.fromJson(json))
        .toList();
  }
}
