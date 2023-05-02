import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontspring/models/category_model.dart';
import 'package:frontspring/services/category_service.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final categoryService = CategoryService();

  List<CategoryModel> categories = [];

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
    getCategories();
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
        title: const Text('Categories'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            Provider.of<AuthService>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: categoryService.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : builListView(context, categories),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Categories'),
        ],
        currentIndex: 1, //New
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String name = '';
          String description = '';
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: const Text("Create Category"),
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
                          onPressed: () {
                            categoryService.create(name, description);
                            Navigator.pop(context);
                            getCategories();
                          },
                          child: new Text("OK"))
                    ],
                  ),
                ],
              );
            },
          );
          // Add your onPressed code here!
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }

  Widget builListView(BuildContext context, List categories) {
    return ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: categories.length,
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
                      Text('${categories[index].id}',
                          style: const TextStyle(fontSize: 20)),
                      Text(
                        categories[index].name,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        categories[index].description,
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
                          String name = '${categories[index].name}' ?? '';
                          String description =
                              '${categories[index].description}' ?? '';
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: const Text("Modify Category"),
                                content: SizedBox(
                                  height: 150,
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
                                        decoration: const InputDecoration(
                                            hintText: 'Name'),
                                      ),
                                      TextFormField(
                                        initialValue: description,
                                        onChanged: (String textTyped) {
                                          setState(() {
                                            description = textTyped;
                                          });
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: 'Description'),
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
                                          onPressed: () {
                                            categoryService.update(
                                              categories[index].id.toString(),
                                              name,
                                              description,
                                            );
                                            Navigator.pop(context);
                                            getCategories();
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
                      SizedBox(
                        height: 30,
                      ),
                      GFIconButton(
                        color: Colors.red.shade900,
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete Category'),
                              content: const Text('Are you sure?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    categoryService.delete(
                                        categories[index].id.toString());
                                    Navigator.pop(context);
                                    getCategories();
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
    );
  }
}
