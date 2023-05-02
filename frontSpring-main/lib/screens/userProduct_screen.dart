// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frontspring/models/category_model.dart';
import 'package:frontspring/services/category_service.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';

class userProductScreen extends StatefulWidget {
  const userProductScreen({Key? key}) : super(key: key);

  @override
  State<userProductScreen> createState() => _userProductScreenState();
}

class _userProductScreenState extends State<userProductScreen> {
  final productService = ProductService();
  final categoryService = CategoryService();
  final authService = AuthService();
  bool buttonState = false;
  List<ProductModel> productos = [];
  List<CategoryModel> categories = [];
  List<int> favoritos = [];

  Future getProducts() async {
    await productService.getListProducts();
    setState(() {
      productos.clear();
      productos = productService.productData;
    });
  }

  getProductsCategory(String id) async {
    await productService.getProductsbyCategory(id);
    setState(() {
      productos.clear();
      productos = productService.product;
    });
  }

  Future getFavorites() async {
    await productService.getFav();
    setState(() {
      favoritos.clear();
      favoritos = productService.favorites;
    });
    print("favoritos" + favoritos.toString());
  }

  Future getCategories() async {
    await categoryService.getCategories();
    setState(() {
      categories.clear();
      categories = categoryService.categorias;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
    getCategories();
    getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            Provider.of<AuthService>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: builListView(context, productos),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'favProducts');
        },
        backgroundColor: Colors.red.shade300,
        child: const Icon(
          Icons.favorite_outline_outlined,
          size: 40,
        ),
      ),
      // ),
    );
  }

  Widget builListView(BuildContext context, productos) {
    return Column(children: [
      const SizedBox(
        height: 20,
      ),
      Container(
        width: 300.0,
        child: DropdownButtonFormField(
          icon: const Icon(Icons.keyboard_double_arrow_down_rounded),
          hint: const Text('Select a Category'),
          iconSize: 40,
          items: [
            DropdownMenuItem(
              value: 0,
              child: Text('All Products'),
            ),
            ...categories.map((e) {
              return DropdownMenuItem(
                value: e.id,
                child: Text(e.name.toString()),
              );
            }).toList(),
          ],
          onChanged: (value) {
            buttonState = true;
            if (value == 0) {
              getProducts();
            } else {
              getProductsCategory(value.toString());
            }
          },
          validator: (value) {
            return (value != null && value != 0) ? null : 'Select Category';
          },
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.60,
        child: ListView.builder(
            itemCount: productos.length,
            padding: const EdgeInsets.all(30),
            itemBuilder: (BuildContext context, index) {
              int idProducto = productos[index].id;
              bool esFavorito = favoritos.contains(idProducto);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(productos[index].name,
                            style: TextStyle(fontSize: 20)),
                        subtitle: Text(productos[index].description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${productos[index].price.toStringAsFixed(2)}€',
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(width: 60),
                            GestureDetector(
                              onTap: () {
                                print(idProducto.toString());
                                setState(() {
                                  if (esFavorito) {
                                    productService
                                        .delFav(idProducto.toString());
                                    favoritos.remove(idProducto);
                                  } else {
                                    productService
                                        .addFav(idProducto.toString());
                                    favoritos.add(idProducto);
                                  }
                                });
                              },
                              child: Icon(
                                esFavorito
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: esFavorito ? Colors.red : null,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              );
            }),
      )
    ]);
  }
}
