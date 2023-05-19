import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/cupertino.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:nutrigains_front/models/food_model.dart';

import '../services/food_service.dart';
import '../services/meal_service.dart';
import '../widgets/CustomIconButton.dart';
import '../widgets/GenericBottomNavigationBar.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  List<FoodModel> foodList = [];
  bool isLoading = true;
  List<FoodModel> elementosSeleccionados = [];
  List<int> selectedQuantities = [];

  int _currentIndex = 2;
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
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  getAllUserFood() async {
    List<FoodModel> list = await FoodService().getAllUserFood();

    setState(() {
      foodList = list;
      elementosSeleccionados = [];
      selectedQuantities = List.generate(list.length, (_) => 0);
      print(selectedQuantities);
    });
  }

  Future<void> initializeData() async {
    await getAllUserFood();

    setState(() {
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? _buildLoadingScreen()
          : Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: foodList.length,
                      itemBuilder: (context, index) {
                        final data = foodList[index];
                        bool isSelected = elementosSeleccionados.contains(data);

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
                            color: isSelected ? Colors.blue : Colors.white,
                            child: ListTile(
                              title: Text(data.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Kcal: ${data.kcal}'),
                                  Text('Carbohydrates: ${data.carbohydrates}'),
                                  Text('Protein: ${data.protein}'),
                                  // Agrega más widgets Text o cualquier otro widget necesario para mostrar la información adicional
                                ],
                              ),
                              trailing: Container(
                                margin: EdgeInsets.all(10),
                                width: 100,
                                height: 50,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    hintText: 'grams',
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedQuantities[index] =
                                          int.tryParse(value) ?? 0;
                                      print(selectedQuantities);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
                int position = elementosSeleccionados.indexOf(element);
                int grams = selectedQuantities[position];
                print('Elemento: $element, Posición: $position');
                MealService().newFoodMeal(element.id!, position);
              }
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
