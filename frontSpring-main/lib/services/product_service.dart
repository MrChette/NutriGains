// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontspring/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.140:8080';
  bool isLoading = true;
  List<ProductModel> productData = [];
  List<ProductModel> product = [];
  List<int> favorites = [];

  Future<List> getListProducts() async {
    print("Entrando");
    productData.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/api/all/products');
    String? token = await AuthService().readToken();
    print(token);

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    print("Resp " + resp.body);
    final List<dynamic> decodedResp = json.decode(resp.body);
    List<ProductModel> categoryList = decodedResp
        .map((e) => ProductModel(
              id: e['id'],
              name: e['name'],
              description: e['description'],
              idCategory: e['idCategory'],
              price: e['price'],
            ))
        .toList();
    print(categoryList);
    productData = categoryList;

    // var catalog = ProductModel.fromJson(decodedResp);
    // print(catalog);
    isLoading = false;
    notifyListeners();
    return categoryList;
  }

  getProductsbyCategory(String id) async {
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, 'api/user/categories/$id/products');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final List<dynamic> decodedResp = json.decode(resp.body);

    List<ProductModel> productList = decodedResp
        .map((e) => ProductModel(
              id: e['id'],
              name: e['name'],
              description: e['description'],
              price: e['price'],
              idCategory: e['idCategory'],
            ))
        .toList();

    product = productList;
    isLoading = false;
    notifyListeners();
    return product;
  }

  addFav(String id) async {
    String? token = await AuthService().readToken();

    bool _isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/user/addFav/$id');

    final resp = await http.post(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    print(resp.statusCode);
    _isLoading = false;
    notifyListeners();

    if (resp.statusCode == 200) {}
  }

  delFav(String id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/user/delFav/$id');
    final resp = await http.post(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    isLoading = false;
    notifyListeners();

    print(resp.statusCode);

    if (resp.statusCode == 200) {}
  }

  Future getFav() async {
    String? token = await AuthService().readToken();
    favorites.clear();
    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/user/getFavs');

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    print("hollaaaa");
    final List<dynamic> decodedResp = json.decode(resp.body);
    favorites = decodedResp.cast<int>();

    isLoading = false;
    notifyListeners();
    print(resp.statusCode);

    if (resp.statusCode == 200) {}

    return favorites;
  }

  Future deleteProduct(String id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/admin/products/$id');

    final resp = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    isLoading = false;
    notifyListeners();
    print(resp.statusCode);
    if (resp.statusCode == 200) {}
  }

  Future modify(
    int id,
    String name,
    String description,
    String price,
  ) async {
    String? token = await AuthService().readToken();
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'name': name,
      'description': description,
      'price': price,
    };
    print(productData);
    print(json.encode(productData));

    final url = Uri.http(_baseUrl, '/api/admin/products/$id');

    final resp = await http.put(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(productData),
    );
    isLoading = false;
    notifyListeners();

    print(resp.statusCode);

    if (resp.statusCode == 200) {}
  }

  Future create(
    int idCategory,
    String name,
    String description,
    String price,
  ) async {
    String? token = await AuthService().readToken();
    isLoading = false;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'name': name,
      'description': description,
      'price': price,
      'idCategory': idCategory,
    };
    print(productData);
    print(json.encode(productData));

    final url = Uri.http(_baseUrl, '/api/admin/categories/$idCategory/product');

    final resp = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(productData),
    );
    isLoading = false;
    notifyListeners();
    print(resp.statusCode);

    if (resp.statusCode == 200) {}
  }
}
