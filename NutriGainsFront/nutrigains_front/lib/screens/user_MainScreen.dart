// ignore_for_file: camel_case_types, no_leading_underscores_for_local_identifiers

import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrigains_front/models/onlyNutriment_mode.dart';
import 'package:nutrigains_front/services/recipe_service.dart';
import 'package:nutrigains_front/widgets/CustomIconButton.dart';
import 'package:provider/provider.dart';
import '../models/food_model.dart';
import '../models/meal_model.dart';
import '../models/recipe_model.dart';
import '../services/auth_service.dart';
import '../services/food_service.dart';
import '../services/meal_service.dart';
import '../widgets/CustomToast.dart';
import '../widgets/GenericBottomNavigationBar.dart';

class userMainScreen extends StatefulWidget {
  const userMainScreen({Key? key}) : super(key: key);

  @override
  State<userMainScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<userMainScreen> {
  final AuthService authService = AuthService();
  String username = '';
  int limitKcal = 0;
  TextEditingController _textEditingController = TextEditingController();

  final List<String> items = ['Change Limit Kcal'];
  String? selectedValue;

  List<MealModel> todaymeals = [];
  late onlyNutriment todayNutriments;
  bool isLoading = true;

  List<FoodModel> foodList = [];
  List<RecipeModel> recipeList = [];

  void _showSelectedOption(String option, BuildContext context) {
    if (option == 'Change calorie limit') {
      final TextEditingController dialogController =
          TextEditingController(text: limitKcal.toString());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              // Cierra el cuadro de diálogo al hacer clic fuera
              Navigator.of(context).pop();
            },
            child: AlertDialog(
              contentPadding: const EdgeInsets.symmetric(vertical: 24.0),
              content: FractionallySizedBox(
                widthFactor: 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Modify your daily calorie limit.'),
                    TextFormField(
                      controller: dialogController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Calorie Limit',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                CustomIconButton(
                  onPressed: () async {
                    String calorieLimit = dialogController.text;
                    await authService.setLimitKcal(int.parse(calorieLimit));
                    // ignore: use_build_context_synchronously
                    CustomToast.customToast('Daily calories updated!', context);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    initializeData();
                  },
                  icon: Icons.save,
                ),
              ],
            ),
          );
        },
      );
    }
  }

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
    } else if (index == 3) {
      Navigator.pushNamed(context, 'commentScreen');
    }
  }

  getUsername() async {
    int userlimitKcal = await authService.getLimitKcal();
    String user = await authService.getUserName();
    setState(() {
      username = user;
      limitKcal = userlimitKcal;
    });
  }

  void deleteMeal(int mealId, int? foodIndex, int? recipeIndex) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    CustomToast.customToast(await MealService().deleteMeal(mealId), context);
    onlyNutriment todayNutrimentsEnd =
        await MealService().getTodayKcal(formattedDate);
    setState(() {
      todaymeals.removeWhere((meal) => meal.id == mealId);
      if (foodIndex != null) {
        foodList.removeAt(foodIndex);
      }
      if (recipeIndex != null) {
        recipeList.removeAt(recipeIndex - foodList.length);
      }
      todayNutriments = todayNutrimentsEnd;
    });
  }

  getTodayMeals() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final List<MealModel> meals =
        await MealService().getMealByDate(formattedDate);
    final onlyNutriment todayNutrimentsEnd =
        await MealService().getTodayKcal(formattedDate);
    List<int> recipesId = [];
    for (var meal in meals) {
      if (meal.food_id != null) {
        FoodModel theFood = await FoodService().getFood(meal.food_id!);
        foodList.add(theFood);
      } else {
        recipesId.add(meal.recipe_id!);
      }
    }
    List<RecipeModel> theRecipe = await RecipeService().getRecipes(recipesId);
    recipeList = theRecipe;
    setState(() {
      todaymeals = meals;
      todayNutriments = todayNutrimentsEnd;
    });
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
    setState(() {
      isLoading = false;
    });

    if (limitKcal == 0) {
      // Muestra el cuadro de diálogo si limitKcal es igual a 0
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final formKey =
              GlobalKey<FormState>(); // Crear un GlobalKey<FormState> local

          return WillPopScope(
            onWillPop: () async =>
                false, // Evitar el cierre al presionar el botón de retroceso
            child: AlertDialog(
              title: const Text('Welcome!'),
              contentPadding: const EdgeInsets.symmetric(vertical: 24.0),
              content: FractionallySizedBox(
                widthFactor: 0.8,
                child: Form(
                  key:
                      formKey, // Asignar el GlobalKey<FormState> local al formulario
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Please set your daily calorie limit.'),
                      TextFormField(
                        controller: _textEditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Calorie Limit',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a calorie limit.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      String calorieLimit = _textEditingController.text;
                      await authService.setLimitKcal(int.parse(calorieLimit));
                      Navigator.of(context)
                          .pop(); // Cerrar el cuadro de diálogo manualmente
                      initializeData();
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: userCard(context),
                      ),
                      const SizedBox(height: 25.0),
                      Center(
                        child: Text(
                          "Today you have ${todaymeals.length} meals",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Center(
                        child: circularStats(
                            context, todayNutriments, limitKcal.toDouble()),
                      ),
                      const SizedBox(height: 25.0),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: cardList(context, foodList, recipeList,
                            todaymeals, deleteMeal),
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: GenericBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarItemTapped,
      ),
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
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.login_outlined,
                  size: 35,
                  color: Colors.red,
                ),
                onPressed: () {
                  Provider.of<AuthService>(context, listen: false).logout();
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Hello, $username',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<String>(
                onSelected: (option) => _showSelectedOption(option, context),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Change calorie limit',
                    child: Text('Change calorie limit'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget circularStats(
  BuildContext context,
  onlyNutriment _todayProgress,
  double _maxprogress,
) {
  ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  // Calculate the remaining progress after reaching maxprogress
  double remainingProgress =
      (_todayProgress.carbohydrates - _maxprogress).clamp(0, double.infinity);

  final String protein = _todayProgress.protein.toStringAsFixed(1);
  String carbs = _todayProgress.carbohydrates.toStringAsFixed(1);
  String fat = _todayProgress.fat.toStringAsFixed(1);

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
            animation: true,
            animDurationMillis: 500,
            curves: Curves.ease,
            interactive: false,
            width: double.infinity,
            height: 250,
            minProgress: 0,
            progress: _todayProgress.kcal > _maxprogress
                ? _maxprogress
                : _todayProgress.kcal,
            maxProgress: _maxprogress,
            barWidth: 30,
            startAngle: 50,
            sweepAngle: 260,
            strokeCap: StrokeCap.round,
            trackColor: Theme.of(context).canvasColor,
            progressGradientColors: [
              Colors.amber,
              const Color.fromARGB(255, 255, 89, 0),
              if (remainingProgress > 0) Colors.red,
            ],
            dashWidth: 10,
            dashGap: 0,
            valueNotifier: _valueNotifier,
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: _valueNotifier,
                builder: (_, double value, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_todayProgress.kcal.toInt()}',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: _todayProgress.kcal > _maxprogress
                            ? const Color.fromARGB(255, 245, 16, 0)
                            : Colors.black,
                      ),
                    ),
                    Text(
                      '/${_maxprogress.toInt()}',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'PROTEIN',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        protein,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'CARBS',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        carbs,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'FAT',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        fat,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget cardList(
    BuildContext context,
    List<FoodModel> foodList,
    List<RecipeModel> recipeList,
    List<MealModel> todaymeals,
    Function(int, int?, int?) onDeleteMeal) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: foodList.length + recipeList.length,
    itemBuilder: (context, index) {
      int mealIndex;
      if (index < foodList.length) {
        final foodModel = foodList[index];
        mealIndex =
            todaymeals.indexWhere((meal) => meal.food_id == foodModel.id);
        return FractionallySizedBox(
          widthFactor: 0.85,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 90,
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 19, 16, 0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        foodModel.name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Text(
                      todaymeals[mealIndex].grams != null
                          ? "${(foodModel.kcal! * todaymeals[mealIndex].grams! / 100).toStringAsFixed(0)} Kcal"
                          : "Grams is null",
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    onDeleteMeal(todaymeals[mealIndex].id!, index, null);
                  },
                ),
              ),
            ),
          ),
        );
      } else {
        final recipeIndex = index - foodList.length;
        final recipeModel = recipeList[recipeIndex];
        mealIndex =
            todaymeals.indexWhere((meal) => meal.recipe_id == recipeModel.id);
        return FractionallySizedBox(
          widthFactor: 0.85,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 90,
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 19, 16, 0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        recipeModel.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Text("${recipeModel.kcal.toStringAsFixed(0)} Kcal"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    onDeleteMeal(todaymeals[mealIndex].id!, null, index);
                  },
                ),
              ),
            ),
          ),
        );
      }
    },
  );
}
