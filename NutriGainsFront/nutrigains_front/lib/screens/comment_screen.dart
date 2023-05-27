import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutrigains_front/services/recipe_service.dart';

import '../models/comment_model.dart';
import '../models/recipe_model.dart';
import '../services/comment_service.dart';
import '../widgets/GenericBottomNavigationBar.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentScreen> {
  List<CommentModel> listaComments = [];
  Set<int> idRecipes = <int>{};
  List<RecipeModel> listaRecetas = [];
  bool isLoading = true;

  int _currentIndex = 3;
  void _onNavBarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushNamed(context, 'userMainScreen');
    } else if (index == 1) {
      Navigator.pushNamed(context, 'recipeScreen');
    } else if (index == 2) {
      Navigator.pushNamed(context, 'foodScreen');
    } else if (index == 3) {
      Navigator.pushNamed(context, 'commentScreen');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  getComments() async {
    try {
      List<CommentModel> commentsData = await CommentService().getAllComments();
      Set<int> uniqueIds = <int>{};
      List<RecipeModel> recipes = [];
      for (CommentModel comment in commentsData) {
        uniqueIds.add(comment.recipe_id);
      }
      for (int id in uniqueIds) {
        recipes.add(await RecipeService().getRecipe(id));
      }
      setState(() {
        listaComments = commentsData;
        idRecipes = uniqueIds;
        listaRecetas = recipes;
      });
    } catch (error) {
      // Manejo del error
      print('Error al obtener los comentarios: $error');
    }
  }

  Future<void> initializeData() async {
    await getComments();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: GenericBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return _buildCommentsList();
    }
  }

  Widget _buildCommentsList() {
    return Column(
      children: [
        SizedBox(height: 16), // Agregar SizedBox encima del ListView
        Expanded(
          child: ListView.builder(
            itemCount: listaRecetas.length,
            itemBuilder: (context, index) {
              RecipeModel recipe = listaRecetas.elementAt(index);
              List<CommentModel> comments = listaComments
                  .where((comment) => comment.recipe_id == recipe.id)
                  .toList();
              return Container(
                margin: EdgeInsets.fromLTRB(12.0, 0, 12.0, 30),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                recipe.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Kcal : ${recipe.kcal.toStringAsFixed(1)}      Protein : ${recipe.protein.toStringAsFixed(1)}     Carbs : ${recipe.carbohydrates.toStringAsFixed(1)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      for (var comment in comments)
                        Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.comment,
                                size: 20,
                              ),
                              title: Text(
                                comment.comment,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
