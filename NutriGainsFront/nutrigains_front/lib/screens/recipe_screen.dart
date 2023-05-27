import 'package:flutter/material.dart';
import 'package:nutrigains_front/models/recipe_model.dart';
import 'package:nutrigains_front/services/meal_service.dart';
import 'package:nutrigains_front/services/recipeList_service.dart';

import '../services/recipe_service.dart';
import '../widgets/CustomIconButton.dart';
import '../widgets/GenericBottomNavigationBar.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _recipeScreen();
}

class _recipeScreen extends State<RecipeScreen> {
  List<RecipeModel> recipeList = [];
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

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  getAllUserRecipes() async {
    List<RecipeModel> list = await RecipeService().getalluserrecipe();
    setState(() {
      recipeList = list;
      elementosSeleccionados = [];
    });
  }

  Future<void> initializeData() async {
    getAllUserRecipes();

    // Todas las operaciones se han completado, actualiza el estado
    print("true");
    setState(() {
      print("false");
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
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
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing:
                            20.0, // Espacio vertical entre los elementos
                        mainAxisSpacing: 20.0,
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
                                title: Text(data.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Kcal: ${data.kcal}'),
                                    Text(
                                        'Carbohydrates: ${data.carbohydrates}'),
                                    Text('Protein: ${data.protein}'),
                                    // Agrega más widgets Text o cualquier otro widget necesario para mostrar la información adicional
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
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 100.0),
            width: MediaQuery.of(context).size.width * 1,
            child: CustomIconButton(
              icon: Icons.add,
              label: 'ADD MEAL',
              onPressed: () async {
                for (var element in elementosSeleccionados) {
                  MealService().newRecipeMeal(element.id);
                }
              },
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
