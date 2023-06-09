import 'package:flutter/material.dart';
import 'package:nutrigains_front/models/food_model.dart';
import 'package:nutrigains_front/models/recipe_model.dart';
import 'package:nutrigains_front/models/recipeList_model.dart';
import 'package:nutrigains_front/services/food_service.dart';
import 'package:nutrigains_front/services/meal_service.dart';
import 'package:nutrigains_front/services/recipeList_service.dart';
import 'package:nutrigains_front/services/recipe_service.dart';
import 'package:nutrigains_front/widgets/CustomIconButton.dart';
import 'package:nutrigains_front/widgets/CustomToast.dart';
import '../widgets/GenericBottomNavigationBar.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<RecipeModel> recipeList = [];
  List<RecipeListModel> recipeListM = [];
  List<FoodModel> foodList = [];

  List<int> foodIds = [];
  List<int> recipeIds = [];
  bool isLoading = true;
  List<RecipeModel> elementosSeleccionados = [];

  int _currentIndex = 1;

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

  final Map<int, FoodModel> cachedFoods = {};

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getAllUserRecipes();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getAllUserRecipes() async {
    List<RecipeModel> list = await RecipeService().getalluserrecipevisible();
    setState(() {
      recipeList = list;
      elementosSeleccionados = [];
    });
  }

  Future<FoodModel> getFoodByid(int idfood) async {
    if (cachedFoods.containsKey(idfood)) {
      return cachedFoods[idfood]!;
    } else {
      FoodModel food = await FoodService().getFoodById(idfood);
      cachedFoods[idfood] = food;
      return food;
    }
  }

  deleteRecipe(int recipeId) async {
    String response = await RecipeService().deleteRecipe(recipeId);
    CustomToast.customToast(response, context);
    getAllUserRecipes();
  }

  Future<List<RecipeListModel>> getFoods(int recipeId) async {
    List<RecipeListModel> foods =
        await FoodService().getFoodsByIdRecipe(recipeId);
    return foods;
  }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelectedEmpty = elementosSeleccionados.isEmpty;
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: isLoading
          ? _buildLoadingScreen()
          : Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: recipeList.isEmpty
                          ? const Text('')
                          : GridView.count(
                              crossAxisCount: 1,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 20.0,
                              childAspectRatio: 2.3,
                              children: recipeList.map((data) {
                                bool isSelected =
                                    elementosSeleccionados.contains(data);
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        elementosSeleccionados.remove(data);
                                      } else {
                                        elementosSeleccionados.add(data);
                                      }
                                    });
                                  },
                                  child: Card(
                                    color: isSelected
                                        ? Colors.amber
                                        : Theme.of(context).cardColor,
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              // Otros estilos según tus preferencias
                                            ),
                                          ),
                                          const Text(
                                            'Ingredients',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              // Otros estilos según tus preferencias
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Kcal: ${data.kcal.toStringAsFixed(0)}',
                                                    ),
                                                    Text(
                                                      'Carbohydrates: ${data.carbohydrates.toStringAsFixed(0)}',
                                                    ),
                                                    Text(
                                                      'Protein: ${data.protein.toStringAsFixed(0)}',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Builder(builder: (context) {
                                                return FutureBuilder<
                                                    List<RecipeListModel>>(
                                                  future: getFoods(data.id),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Error: ${snapshot.error}');
                                                    } else if (snapshot
                                                        .hasData) {
                                                      List<RecipeListModel>
                                                          foods =
                                                          snapshot.data!;
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          for (var food
                                                              in foods)
                                                            buildFoodFutureBuilder(
                                                                food),
                                                        ],
                                                      );
                                                    } else {
                                                      return const Text(
                                                          'No foods available');
                                                    }
                                                  },
                                                );
                                              }),
                                            ],
                                          ),
                                          Center(
                                            child: IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Confirmation'),
                                                      content: const Text(
                                                          'Are you sure you want to delete this element?'),
                                                      actions: [
                                                        TextButton(
                                                          child: const Text(
                                                            'No',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Cierra el cuadro de diálogo
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: const Text(
                                                            'Yes',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Cierra el cuadro de diálogo
                                                            deleteRecipe(
                                                                data.id);
                                                            //print(index + 1);
                                                            //deleteFood(data.id!, index + 1);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: GenericBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarItemTapped,
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Visibility(
          visible:
              !isSelectedEmpty, // Mostrar solo cuando isSelectedEmpty es falso
          child: Container(
            width: double.infinity, // Ocupar todo el ancho disponible
            margin: const EdgeInsets.symmetric(horizontal: 100.0),
            child: CustomIconButton(
              icon: Icons.add,
              label: 'ADD MEAL',
              onPressed: () async {
                for (var element in elementosSeleccionados) {
                  CustomToast.customToast(
                    await MealService().newRecipeMeal(element.id),
                    context,
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
