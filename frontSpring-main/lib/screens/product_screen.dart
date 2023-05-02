import 'package:flutter/material.dart';
import 'package:frontspring/models/category_model.dart';
import 'package:frontspring/services/category_service.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final productService = ProductService();
  final categoryService = CategoryService();

  List<ProductModel> productos = [];
  List<CategoryModel> categories = [];

  Future getProducts() async {
    await productService.getListProducts();
    setState(() {
      productos.clear();
      productos = productService.productData;
    });
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
  }

  Widget builListView(BuildContext context, List articles) {
    return Scaffold(
        body: productService.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(30),
                itemCount: articles.length,
                itemBuilder: (BuildContext context, index) {
                  return SizedBox(
                    height: 200,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Color(0xFFF5F5F5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${productos[index].id}',
                                    style: const TextStyle(fontSize: 20)),
                                Text(
                                  productos[index].name,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  productos[index].description,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  'Price : ${productos[index].price}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GFIconButton(
                                  onPressed: () {
                                    String name =
                                        '${productos[index].name}' ?? '';
                                    String description =
                                        '${productos[index].description}' ?? '';
                                    String price =
                                        '${productos[index].price}' ?? '';
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          title: const Text("Modify Product"),
                                          content: SizedBox(
                                            height: 150,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  initialValue: name,
                                                  onChanged:
                                                      (String textTyped) {
                                                    setState(() {
                                                      name = textTyped;
                                                    });
                                                  },
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'Name'),
                                                ),
                                                TextFormField(
                                                  initialValue: description,
                                                  onChanged:
                                                      (String textTyped) {
                                                    setState(() {
                                                      description = textTyped;
                                                    });
                                                  },
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              'Description'),
                                                ),
                                                TextFormField(
                                                  initialValue: price,
                                                  onChanged:
                                                      (String textTyped) {
                                                    setState(() {
                                                      price = textTyped;
                                                    });
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'Price'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            Row(
                                              children: <Widget>[
                                                TextButton(
                                                  child: new Text("Cancel"),
                                                  onPressed: () {
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                    onPressed: () async {
                                                      productService.modify(
                                                          productos[index].id,
                                                          name,
                                                          description,
                                                          price);
                                                      Navigator.pop(context);
                                                      getProducts();
                                                    },
                                                    child: new Text("OK"))
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                GFIconButton(
                                  color: Colors.red.shade900,
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Delete Product'),
                                        content: const Text('Are you sure?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              productService.deleteProduct(
                                                  productos[index]
                                                      .id
                                                      .toString());
                                              setState(() {
                                                productos.removeWhere(
                                                    (element) => (element ==
                                                        productos[index]));
                                              });

                                              Navigator.pop(context);
                                              getProducts();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    void _onItemTapped(int index) {
      if (index == 1) {
        Navigator.pushReplacementNamed(context, 'adminCategory');
      } else {
        Navigator.pushReplacementNamed(context, 'adminProducts');
      }
    }

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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Categories'),
        ],
        currentIndex: 0, //New
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int id = 0;
          String name = '';
          String description = '';
          String price = '';
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: const Text("Create Product"),
                content: SizedBox(
                  height: 230,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: name,
                        onChanged: (String textTyped) {
                          setState(() {
                            name = textTyped;
                          });
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(hintText: 'Name'),
                      ),
                      TextFormField(
                        initialValue: description,
                        onChanged: (String textTyped) {
                          setState(() {
                            description = textTyped;
                          });
                        },
                        keyboardType: TextInputType.text,
                        decoration:
                            const InputDecoration(hintText: 'Description'),
                      ),
                      TextFormField(
                        initialValue: price,
                        onChanged: (String textTyped) {
                          setState(() {
                            price = textTyped;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Price'),
                      ),
                      Container(
                        width: 300.0,
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.keyboard_double_arrow_down_rounded),
                          hint: const Text('Select a Category'),
                          iconSize: 40,
                          items: categories.map((e) {
                            return DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            id = value ?? 0;
                          },
                          validator: (value) {
                            return (value != null && value != 0)
                                ? null
                                : 'Select Category';
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  Row(
                    children: <Widget>[
                      TextButton(
                        child: new Text("Cancel"),
                        onPressed: () {
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                          onPressed: () async {
                            productService.create(id, name, description, price);
                            Navigator.pop(context);
                            getProducts();
                          },
                          child: new Text("Save"))
                    ],
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
