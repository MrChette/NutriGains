// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:nutrigains_front/models/comment_model.dart';
import 'package:nutrigains_front/models/food_model.dart';
import 'package:nutrigains_front/models/mealList_model.dart';
import 'package:nutrigains_front/services/food_service.dart';
import 'package:nutrigains_front/services/recipeList_service.dart';
import 'package:nutrigains_front/services/recipe_service.dart';
import 'package:provider/provider.dart';

import '../models/meal_model.dart';
import '../providers/login_provider.dart';
import '../services/auth_service.dart';
import '../services/comment_service.dart';
import '../services/mealList_service.dart';
import '../services/meal_service.dart';
import '../ui/input_decorations.dart';
import '../widgets/auth_background.dart';
import '../widgets/card_container.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AuthBackground(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                  child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text('Login',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      )),
                  const SizedBox(height: 60),
                  ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(), child: _LoginForm())
                ],
              )),
              const SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'register'),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Text(
                    'Crear una nueva cuenta',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
              const SizedBox(height: 50),
            ],
          ),
        )));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.amber,
                width: 4,
              ),
            ),
            child: TextFormField(
              autocorrect: false,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'username',
                  labelText: 'Username',
                  prefixIcon: Icons.person),
              onChanged: (value) => loginForm.username = value,
            ),
          ),
          const SizedBox(height: 60),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.amber,
                width: 4,
              ),
            ),
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: '*****',
                      labelText: 'Contraseña',
                      prefixIcon: Icons.lock_outline),
                  onChanged: (value) => loginForm.password = value,
                  validator: (value) {
                    return (value != null && value.length >= 5)
                        ? null
                        : 'La contraseña debe de ser mayor de 5 caracteres';
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 70),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.black,
              elevation: 1,
              color: Colors.amber,
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (!loginForm.isValidForm()) return;

                      // validar si el login es correcto
                      final String? data = await authService.login(
                          loginForm.username, loginForm.password);
                      final spliter = data?.split(',');
                      loginForm.isLoading = true;
                      if (spliter?[0] == '200') {
                        if (spliter?[1] == 'ROLE_ADMIN') {
                          Navigator.pushReplacementNamed(context, '');
                        } else {
                          Navigator.pushReplacementNamed(
                              context, 'userMainScreen');
                        }

                        ////////////////////////////////////////////////////////////////////////////////////////
                        //                     //
                        //                     //
                        // PRUEBA DE ENDPOINTS //
                        //                     //
                        //                     //

                        //  NEWRECIPE //
                        //await RecipeService().newRecipe("Prueba desde flutter 2");

                        //  NEWFOOD //
                        //final food = FoodModel(
                        //    name: "Prueba desde flutter",
                        //    carbohydrates: 100.0,
                        //    fat: 100.0,
                        //    kcal: 100.0,
                        //    protein: 100.0,
                        //    salt: 100.0,
                        //    sugar: 100.0);
                        //await FoodService().newFood(food);

                        // NEWFOODBYBARCODE  //
                        //FoodService().newFoodByApi(3168930009078);

                        //  GETALLUSERFOOD //
                        //List<FoodModel> foodList;
                        //foodList = await FoodService().getAllUserFood();
                        //foodList.forEach((food) {
                        //  print(food.toString());
                        //});

                        //  NEWCOMMENT  //
                        //await CommentService().newComment(1, "Probando un comentario desde flutter");

                        // COMMENTBYIDRECIPE //
                        //List<CommentModel> commentList;
                        //commentList =
                        //    await CommentService().commentByIdRecipe(1);
                        //commentList.forEach((comment) {
                        //  print(comment.toString());
                        //});

                        //  ADDFOODTOMEAL - LIST -  ADDRECIPETOMEAL //
                        //if (mealResult != null) {
                        //  await MealListService()
                        //      .addFoodToMeal(mealResult.id, 105);
                        //  await MealListService()
                        //      .addRecipeToMeal(mealResult.id, 1);
                        //} else {
                        //  print('No se pudo crear la comida');
                        //}

                        // GETMEALISTBYIDMEAL //
                        //List<MealListModel> mealList =
                        //    await MealListService().getMealListByIdMeal(1);
                        //mealList.forEach((meal) {
                        //  print(meal.toString());
                        //});

                        //  NEWMEAL  //
                        //MealModel? mealResult;
                        //mealResult = await MealService().newMeal();

                        // GETMEALBYID //
                        //MealModel meal;
                        //meal = await MealService().getMealById(1);
                        //print(meal.toString());

                        //  GETMEALBYDATE //
                        //DateTime now = DateTime.now();
                        //String formattedDate =
                        //    "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                        //print(formattedDate);
                        //final List<MealModel> meals =
                        //    await MealService().getMealByDate(formattedDate);
                        //meals.length;

                        // ADDFOODTORECIPE //
                        //RecipeListService().addFoodToRecipe(1, 1);
                        //RecipeListService().addFoodToRecipe(1, 2);

                        //                     //
                        //                     //
                        // PRUEBA DE ENDPOINTS //
                        //                     //
                        //                     //
                        ////////////////////////////////////////////////////////////////////////////////////////
                      } else {
                        customToast('Email or password incorrect', context);
                        Navigator.pushReplacementNamed(context, 'login');
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(loginForm.isLoading ? 'Espere' : 'Ingresar',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black45,
                    )),
              )),
        ],
      ),
    );
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
}
