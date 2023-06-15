import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nutrigains_front/services/recipe_service.dart';

import '../models/comment_model.dart';
import '../models/food_model.dart';
import '../models/recipeList_model.dart';
import '../models/recipe_model.dart';
import '../services/comment_service.dart';
import '../services/food_service.dart';
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

  Widget buildFoodFutureBuilder(RecipeListModel food) {
    return FutureBuilder<FoodModel>(
      future: getFoodByid(food.idFood),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          FoodModel foodModel = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${food.grams}g ',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  // Agrega otros estilos según tus preferencias
                ),
              ),
              Text(
                foodModel.name!,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  // Agrega otros estilos según tus preferencias
                ),
              ),
            ],
          );
        } else {
          return const Text('No food available');
        }
      },
    );
  }

  final Map<int, FoodModel> cachedFoods = {};
  Future<FoodModel> getFoodByid(int idfood) async {
    if (cachedFoods.containsKey(idfood)) {
      return cachedFoods[idfood]!;
    } else {
      FoodModel food = await FoodService().getFoodById(idfood);
      cachedFoods[idfood] = food;
      return food;
    }
  }

  Future<List<RecipeListModel>> getFoods(int recipeId) async {
    List<RecipeListModel> foods =
        await FoodService().getFoodsByIdRecipe(recipeId);
    return foods;
  }

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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    recipe.name,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomIconButton(
                                    icon: Icons.add_shopping_cart_sharp,
                                    padding: const EdgeInsets.all(3),
                                    onPressed: () async {
                                      CustomToast.customToast(
                                        await RecipeService()
                                            .addexternalRecipe(recipe.id),
                                        context,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Builder(builder: (context) {
                                      return FutureBuilder<
                                          List<RecipeListModel>>(
                                        future: getFoods(recipe.id),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (snapshot.hasData) {
                                            List<RecipeListModel> foods =
                                                snapshot.data!;
                                            return Column(
                                              children: [
                                                for (var food in foods)
                                                  buildFoodFutureBuilder(food),
                                              ],
                                            );
                                          } else {
                                            return const Text(
                                                'No foods available');
                                          }
                                        },
                                      );
                                    }),
                                  ),
                                ],
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
