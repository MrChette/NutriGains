// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:nutrigains_front/models/food_model.dart';
import '../services/food_service.dart';
import '../services/meal_service.dart';
import '../services/recipeList_service.dart';
import '../widgets/CustomIconButton.dart';
import '../widgets/CustomToast.dart';
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
  int _scanBarcode = 0;

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
    } else if (index == 3) {
      Navigator.pushNamed(context, 'commentScreen');
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
    });
  }

  Future<void> initializeData() async {
    await getAllUserFood();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = int.parse(barcodeScanRes);
    });
  }

  addBarcodeButton(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35.0),
        width: MediaQuery.of(context).size.width * 1,
        child: CustomIconButton(
          icon: Icons.camera,
          label: 'SCAN BARCODE',
          onPressed: () async {
            await scanBarcodeNormal();
            var result = await FoodService().findFoodinBbdd(_scanBarcode);
            if (result == null) {
              CustomToast.customToast(
                  await FoodService().newFoodByApi(_scanBarcode), context);
              Navigator.pop(context);
              initializeData();
            } else {
              CustomToast.customToast('You already have this food', context);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelectedEmpty = elementosSeleccionados.isEmpty;

    return Scaffold(
      body: isLoading
          ? _buildLoadingScreen()
          : Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 2,
                      children:
                          List.generate((foodList.length / 2).ceil(), (index) {
                        final startIndex = index * 2;
                        final endIndex = startIndex + 1;
                        final rowData =
                            foodList.sublist(startIndex, endIndex + 1);
                        return Row(
                          children: rowData.map((data) {
                            bool isSelected =
                                elementosSeleccionados.contains(data);
                            return Expanded(
                              child: InkWell(
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
                                    title: Text(
                                      data.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              "${data.kcal} - Kcal",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                // Otros atributos de estilo que desees aplicar
                                              ),
                                            ),
                                            Text(
                                              '${data.carbohydrates}  - Carbs',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                // Otros atributos de estilo que desees aplicar
                                              ),
                                            ),
                                            Text(
                                              '${data.protein}  - Protein',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                // Otros atributos de estilo que desees aplicar
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Center(
                                          child: IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              // Aquí puedes agregar la lógica para el botón delete
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75.0),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isSelectedEmpty) Expanded(child: addSetGrams(context)),
                const SizedBox(width: 10.0),
                Expanded(child: addMealButton(context)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: GenericBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarItemTapped,
      ),
    );
  }

  Widget addSetGrams(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomIconButton(
          icon: Icons.settings,
          label: 'SET GRAMS',
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                List<TextEditingController> textControllers = [];
                return AlertDialog(
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: ListView.builder(
                      itemCount: elementosSeleccionados.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        var elemento = elementosSeleccionados[index];
                        TextEditingController controller =
                            TextEditingController();
                        textControllers.add(controller);
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                elemento.name,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ), // Espacio entre el nombre y el TextField
                            Expanded(
                              child: TextField(
                                controller:
                                    controller, // Asignar el controlador al TextField
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Grams',
                                ),
                                onChanged: (value) {
                                  // Aquí puedes guardar el valor ingresado para cada elemento
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centra los botones horizontalmente
                      children: [
                        CustomIconButton(
                          label: 'ADD TO MEAL',
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3.0, vertical: 8.0),
                          onPressed: () async {
                            List<int> foodIds = elementosSeleccionados
                                .map((element) => element.id)
                                .where((id) => id != null)
                                .map((id) => id!)
                                .toList();
                            List<int> gramsList = textControllers
                                .map((controller) =>
                                    int.tryParse(controller.text) ?? 0)
                                .toList();
                            CustomToast.customToast(
                                await MealService()
                                    .newFoodMeal(foodIds, gramsList),
                                context);
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(
                            width: 30.0), // Espacio entre los botones
                        CustomIconButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3.0, vertical: 8.0),
                          label: 'CREATE RECIPE',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String recipeName = '';
                                final alertDialogContext = context;

                                return AlertDialog(
                                  title: const Text('Enter Recipe Name'),
                                  content: TextField(
                                    onChanged: (value) {
                                      recipeName = value;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Recipe Name',
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (recipeName.isNotEmpty) {
                                          List<int> foodIds =
                                              elementosSeleccionados
                                                  .map((element) => element.id)
                                                  .where((id) => id != null)
                                                  .map((id) => id!)
                                                  .toList();
                                          List<int> gramsList = textControllers
                                              .map((controller) =>
                                                  int.tryParse(
                                                      controller.text) ??
                                                  0)
                                              .toList();

                                          CustomToast.customToast(
                                              await RecipeListService()
                                                  .foodtorecipe(foodIds,
                                                      gramsList, recipeName),
                                              context);
                                          Navigator.of(alertDialogContext)
                                              .pop();
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget addMealButton(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CustomIconButton(
            icon: Icons.add,
            label: 'ADD FOOD',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("ADD MEAL"),
                    contentPadding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0,
                        0.0), // Ajusta los valores según tus necesidades
                    content: SizedBox(
                      height: 200, // Modifica la altura según tus necesidades
                      child: Column(
                        children: [
                          addBarcodeButton(context),
                          const SizedBox(height: 30.0),
                          foodForm(context),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }

  Widget foodForm(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30.0),
        width: MediaQuery.of(context).size.width * 1,
        child: CustomIconButton(
          icon: Icons.add,
          label: 'Form comida',
          onPressed: () {
            FoodModel foodModel = FoodModel(
              name: '',
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Create Product /100g"),
                  content: SingleChildScrollView(
                    child: SizedBox(
                      height: 350,
                      width: 300,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: foodModel.name,
                            onChanged: (String textTyped) {
                              setState(() {
                                foodModel.name = textTyped;
                              });
                            },
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(hintText: 'Name'),
                          ),
                          TextFormField(
                            onChanged: (String textTyped) {
                              setState(() {
                                foodModel.kcal = double.parse(textTyped);
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: 'Kcal'),
                          ),
                          TextFormField(
                            onChanged: (String textTyped) {
                              setState(() {
                                foodModel.protein = double.parse(textTyped);
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(hintText: 'Protein'),
                          ),
                          TextFormField(
                            onChanged: (String textTyped) {
                              setState(() {
                                foodModel.carbohydrates =
                                    double.parse(textTyped);
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: 'Carbohydrates'),
                          ),
                          TextFormField(
                            onChanged: (String textTyped) {
                              setState(() {
                                foodModel.fat = double.parse(textTyped);
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: 'Fat'),
                          ),
                          TextFormField(
                            onChanged: (String textTyped) {
                              setState(() {
                                foodModel.salt = double.parse(textTyped);
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: 'Salt'),
                          ),
                          TextFormField(
                            onChanged: (String textTyped) {
                              setState(() {
                                foodModel.sugar = double.parse(textTyped);
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(hintText: 'Sugar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                right: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                CustomToast.customToast(
                                    await FoodService().newFood(foodModel),
                                    context);
                                Navigator.pop(context);
                                initializeData();
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
