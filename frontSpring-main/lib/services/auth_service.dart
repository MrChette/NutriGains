// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.140:8080';
  final storage = const FlutterSecureStorage();

  // Si retornamos algo, es un error, si no, todo bien!
  Future<String?> register(
    String username,
    String password,
    /*int courseId*/
  ) async {
    final Map<String, dynamic> authData = {
      'username': username,
      'password': password,
    };

    final encodedFormData = utf8.encode(json.encode(authData));
    final url = Uri.http(_baseUrl, '/register');

    final resp = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: encodedFormData);

    if (resp.statusCode == 201) {
      final Map<String, dynamic> decodedResp = json.decode(resp.body);
      await storage.write(key: 'token', value: decodedResp['token']);
      await storage.write(key: 'id', value: decodedResp['id'].toString());

      return (resp.statusCode.toString());
    } else {
      print('Ya existe ese');
      return (resp.statusCode.toString());
    }
  }

  Future<String?> login(String username, String password) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.1.140:8080/login'));

    request.fields['username'] = username;
    request.fields['password'] = password;

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Solicitud enviada con éxito');
      String valores = "";
      await response.stream.transform(utf8.decoder).listen((value) {
        valores = value;
      });

      final Map<String, dynamic> decodedResp = json.decode(valores);
      await storage.write(key: 'token', value: decodedResp['token']);
      await storage.write(key: 'id', value: decodedResp['id'].toString());

      return (response.statusCode.toString() +
          ',' +
          decodedResp['role'] +
          ',' +
          decodedResp['enabled'].toString());
    } else {
      print('Error al enviar la solicitud');
      return (response.statusCode.toString() + ',' + '');
    }

    // await storage.write(key: 'token', value: decodedResp['data']['token']);
    // print(storage);

    // print("Iniciarndo");
    // final Map authData = new Map<String, dynamic>();
    // authData['username'] = username;
    // authData['password'] = password;
    // // 'returnSecureToken': true
    // print(json.encode(authData));

    // final url = Uri.http(_baseUrl, '/login', {});
    // print(url);
    // final resp = await http.post(url, body: authData);
    // print(resp.toString());

    // final Map<String, dynamic> decodedResp = json.decode(resp.body);

    // if (decodedResp['success'] == true) {
    //   // Token hay que guardarlo en un lugar seguro
    //   // decodedResp['idToken'];
    //   await storage.write(key: 'token', value: decodedResp['data']['token']);
    //   await storage.write(
    //       key: 'id', value: decodedResp['data']['id'].toString());
    //   return decodedResp['data']['type'] +
    //       ',' +
    //       decodedResp['data']['actived'].toString();
    // } else {
    //   return decodedResp['message'];
    // }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String> readId() async {
    return await storage.read(key: 'id') ?? '';
  }
}
