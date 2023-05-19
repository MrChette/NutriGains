// ignore: file_names
// ignore_for_file: camel_case_types, no_leading_underscores_for_local_identifiers

import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:nutrigains_front/models/recipeList_model.dart';
import 'package:nutrigains_front/services/recipe_service.dart';
import 'package:provider/provider.dart';
import '../models/food_model.dart';
import '../models/meal_model.dart';
import '../models/recipe_model.dart';
import '../services/auth_service.dart';
import '../services/food_service.dart';

import '../services/meal_service.dart';
import '../widgets/CustomIconButton.dart';
import '../widgets/GenericBottomNavigationBar.dart';

class userMainScreen extends StatefulWidget {
  const userMainScreen({Key? key}) : super(key: key);

  @override
  State<userMainScreen> createState() => _HomeScreenState();
}

void customToast(String s, BuildContext context) {
  showToast(
    s,
    context: context,
    animation: StyledToastAnimation.scale,
    reverseAnimation: StyledToastAnimation.fade,
    position: StyledToastPosition.top,
    animDuration: const Duration(seconds: 1),
    duration: const Duration(seconds: 4),
    curve: Curves.elasticOut,
    reverseCurve: Curves.linear,
  );
}

class _HomeScreenState extends State<userMainScreen> {
  final AuthService authService = AuthService();
  String username = '';
  int _scanBarcode = 0;
  List<MealModel> todaymeals = [];
  double todaykcal = 0;
  bool isLoading = true;
  int _currentIndex = 0;

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

  getUsername() async {
    String user = await authService.getUserName();
    setState(() {
      username = user;
    });
    print("hecho");
  }

  getTodayMeals() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final List<MealModel> meals =
        await MealService().getMealByDate(formattedDate);
    print(meals.length);
    setState(() {
      todaymeals = meals;
      print("hecho");
    });

    for (MealModel meal in todaymeals) {
      RecipeModel? getRecipe;
      FoodModel? getFood;
      final MealModel fetchedMeal = await MealService().getMealById(meal.id!);
      print('fetchedmeal $fetchedMeal');
      if (fetchedMeal.food_id == null) {
        getRecipe = await RecipeService().getRecipe(fetchedMeal.recipe_id!);
      } else {
        getFood = await FoodService().getFood(fetchedMeal.food_id!);
        //FoodModel getFood = await FoodService().getFood(fetchedMeal.food_id!);
      }
      setState(() {
        if (getRecipe != null) {
          todaykcal += getRecipe.kcal;
        } else {
          todaykcal += getFood!.kcal;
        }
      });
      print("IMPRIMETE $getRecipe.kcal");
    }
    print("todaymeals $todaymeals");
    print("hecho");
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await getUsername();
    await getTodayMeals();

    // Todas las operaciones se han completado, actualiza el estado
    print("true");
    setState(() {
      print("false");
      isLoading = false;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
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
              await FoodService().newFoodByApi(_scanBarcode);
            } else {
              customToast('Ya existe', context);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget foodForm(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35.0),
        width: MediaQuery.of(context).size.width * 1,
        child: CustomIconButton(
          icon: Icons.add,
          label: 'Form comida',
          onPressed: () {
            FoodModel foodModel = FoodModel(
              name: '',
              carbohydrates: 0.0,
              fat: 0.0,
              kcal: 0.0,
              protein: 0.0,
              salt: 0.0,
              sugar: 0.0,
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: const Text("Create Product"),
                  content: SizedBox(
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
                          initialValue: foodModel.carbohydrates.toString(),
                          onChanged: (String textTyped) {
                            setState(() {
                              foodModel.carbohydrates = double.parse(textTyped);
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(hintText: 'Carbohydrates'),
                        ),
                        TextFormField(
                          initialValue: foodModel.fat.toString(),
                          onChanged: (String textTyped) {
                            setState(() {
                              foodModel.fat = double.parse(textTyped);
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Fat'),
                        ),
                        TextFormField(
                          initialValue: foodModel.kcal.toString(),
                          onChanged: (String textTyped) {
                            setState(() {
                              foodModel.kcal = double.parse(textTyped);
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Kcal'),
                        ),
                        TextFormField(
                          initialValue: foodModel.protein.toString(),
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
                          initialValue: foodModel.salt.toString(),
                          onChanged: (String textTyped) {
                            setState(() {
                              foodModel.salt = double.parse(textTyped);
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Salt'),
                        ),
                        TextFormField(
                          initialValue: foodModel.sugar.toString(),
                          onChanged: (String textTyped) {
                            setState(() {
                              foodModel.sugar = double.parse(textTyped);
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Sugar'),
                        ),
                      ],
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
                                await FoodService().newFood(foodModel);
                                Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    var selectedItem = '';
    // ignore: no_leading_underscores_for_local_identifiers
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.grey,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
            icon: const Icon(
              Icons.login_outlined,
              size: 40,
              color: Colors.red,
            ),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.menu_rounded, // Cambia el icono aquí
              size: 40, // Ajusta el tamaño del icono aquí
              color: Colors.white, // Cambia el color del icono aquí
            ),
            onSelected: (value) {
              // your logic
              setState(() {
                selectedItem = value.toString();
              });
              print(value);
              Navigator.pushNamed(context, value.toString());
            },
            itemBuilder: (BuildContext bc) {
              return const [
                PopupMenuItem(
                  child: Text("Hello"),
                  value: '/hello',
                ),
                PopupMenuItem(
                  child: Text("About"),
                  value: '/about',
                ),
                PopupMenuItem(
                  child: Text("Contact"),
                  value: '/contact',
                )
              ];
            },
          ),
          const SizedBox(
            width: 16, // Ajusta el ancho del espacio vacío aquí
          )
        ],
      ),

      ///////////////////////////////////////////////
      ///////////////////////////////////////////////
      //AQUI AÑADIMOS LOS OBJETOS PARA LA PANTALLA //
      ///////////////////////////////////////////////
      ///////////////////////////////////////////////
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: userCard(context),
                ),
                const SizedBox(height: 15.0),
                Center(
                  child: Text(
                    "Today you have ${todaymeals.length} meals",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                addMealButton(context),
                const SizedBox(height: 15.0),
                Center(
                  child: circularStats(context, todaykcal, 2500),
                ),
              ],
            ),
      bottomNavigationBar: GenericBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarItemTapped,
      ),

      ///////////////////////////////////////////////
      ///////////////////////////////////////////////
      //AQUI AÑADIMOS LOS OBJETOS PARA LA PANTALLA //
      ///////////////////////////////////////////////
      ///////////////////////////////////////////////
    );
  }

  Widget userCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.0), // Establece el radio de los bordes
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hello, $username',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget addMealButton(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          width: MediaQuery.of(context).size.width * 0.9,
          child: CustomIconButton(
            icon: Icons.add,
            label: 'Añadir comida',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("ADD MEAL"),
                      content: SizedBox(
                        height: 300,
                        child: Column(
                          children: [
                            addFoodButton(context),
                            const SizedBox(height: 30.0),
                            addBarcodeButton(context),
                            const SizedBox(height: 30.0),
                            foodForm(context)
                          ],
                        ),
                      ),
                    );
                  });
              print('Botón presionado');
            },
          ),
        ));
  }
}

Widget circularStats(
  BuildContext context,
  double _progress,
  double _maxprogress,
) {
  ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  // Calculate the remaining progress after reaching maxprogress
  double remainingProgress =
      (_progress - _maxprogress).clamp(0, double.infinity);

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Calories Budget',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          CircularSeekBar(
            interactive: false,
            width: double.infinity,
            height: 250,
            minProgress: 0,
            progress: _progress,
            maxProgress: _maxprogress,
            barWidth: 30,
            startAngle: 50,
            sweepAngle: 260,
            strokeCap: StrokeCap.round,
            trackColor: Colors.grey,
            progressGradientColors: [
              Colors.amber,
              Colors.orange,
              if (remainingProgress > 0) Colors.red,
            ],
            dashWidth: 10,
            dashGap: 0,
            curves: Curves.bounceOut,
            valueNotifier: _valueNotifier,
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: _valueNotifier,
                builder: (_, double value, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_progress.toInt()}/${_maxprogress.toInt()}',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@override
Widget addFoodButton(BuildContext context) {
  return SizedBox(
      child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 35.0),
    width: MediaQuery.of(context).size.width * 1,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(49.0),
      color: Colors.blue, // Cambia el color del botón según tus necesidades
    ),
    child: CustomIconButton(
      icon: Icons.add,
      label: 'Añadir comida',
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text("ADD FOOD"),
                content: SizedBox(
                  height: 300,
                  width: 300,
                ),
              );
            });
        print('Botón presionado');
      },
    ),
  ));
}
