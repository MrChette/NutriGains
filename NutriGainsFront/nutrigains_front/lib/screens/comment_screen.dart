import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutrigains_front/services/recipe_service.dart';

import '../models/comment_model.dart';
import '../models/recipe_model.dart';
import '../services/comment_service.dart';
import '../widgets/CustomIconButton.dart';
import '../widgets/CustomToast.dart';
import '../widgets/GenericBottomNavigationBar.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentScreen> {
  List<CommentModel> listaComments = [];
  List<RecipeModel> recipeList = [];
  bool isLoading = true;
  bool areCommentsVisible = false;
  List<TextEditingController> textControllers = [];

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

  getRecipes() async {
    List<RecipeModel> recipesRecived = await RecipeService().getAllRecipes();
    setState(() {
      recipeList = recipesRecived;
    });
  }

  getComments() async {
    List<CommentModel> commentsData = await CommentService().getAllComments();
    setState(() {
      listaComments = commentsData;
    });
  }

  Future<void> initializeData() async {
    await getComments();
    await getRecipes();
    setState(() {
      textControllers =
          List.generate(recipeList.length, (_) => TextEditingController());
      isLoading = false;
    });
  }

  void addComment(String comment, int recipeId) {
    CommentModel newComment =
        CommentModel(comment: comment, recipe_id: recipeId);
    setState(() {
      listaComments.add(newComment);
    });
  }

  @override
  void dispose() {
    TextEditingController().dispose();
    super.dispose();
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
    return isLoading
        ? _buildLoadingScreen()
        : Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView.separated(
              itemCount: recipeList.length,
              itemBuilder: (context, recipeIndex) {
                RecipeModel recipe = recipeList[recipeIndex];
                // Crear una lista de comentarios asociados a la receta actual
                List<CommentModel> commentsForRecipe = listaComments
                    .where((comment) => comment.recipe_id == recipe.id)
                    .toList();
                return Container(
                  margin: const EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // Utiliza el EdgeInsets personalizado
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre de la receta
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  recipe.name,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              CustomIconButton(
                                icon: Icons.add_shopping_cart_sharp,
                                padding: EdgeInsets.all(3),
                                onPressed: () async {
                                  CustomToast.customToast(
                                      await RecipeService()
                                          .addexternalRecipe(recipe.id),
                                      context);

                                  // Acción a realizar cuando se presiona el botón
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Divider para separar la receta del comentario
                          const Divider(
                            thickness: 3,
                            color: Colors.amber,
                            indent: 0,
                            endIndent: 20,
                          ),
                          const SizedBox(height: 20),
                          // Comentario
                          commentsForRecipe.isNotEmpty
                              ? Column(
                                  children: [
                                    if (areCommentsVisible)
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: commentsForRecipe.length,
                                        itemBuilder: (context, commentIndex) {
                                          CommentModel comment =
                                              commentsForRecipe[commentIndex];
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.amber,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            margin: const EdgeInsets.only(
                                                bottom: 30),
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 0, 10),
                                            child: ListTile(
                                              leading: const Icon(Icons
                                                  .comment), // Ícono a la izquierda
                                              title: Text(comment.comment),
                                              // Otros detalles del comentario
                                            ),
                                          );
                                        },
                                      ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          areCommentsVisible =
                                              !areCommentsVisible;
                                        });
                                      },
                                      child: Center(
                                        child: Text(
                                          areCommentsVisible
                                              ? 'Hide Comments'
                                              : 'Show Comments',
                                          style: const TextStyle(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    'No hay comentarios disponibles',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: textControllers[recipeIndex],
                                  decoration: const InputDecoration(
                                    labelText: 'Comment',
                                  ),
                                ),
                              ),
                              CustomIconButton(
                                icon: Icons.send,
                                padding: const EdgeInsets.all(1),
                                onPressed: () {
                                  addComment(textControllers[recipeIndex].text,
                                      recipe.id);
                                  CommentService().newComment(recipe.id,
                                      textControllers[recipeIndex].text);
                                  textControllers[recipeIndex].clear();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
          );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
