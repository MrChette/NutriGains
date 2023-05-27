import 'package:flutter/material.dart';
import 'package:nutrigains_front/screens/comment_screen.dart';
import 'package:nutrigains_front/screens/food_screen.dart';
import 'package:nutrigains_front/screens/login_screen.dart';
import 'package:nutrigains_front/screens/recipe_screen.dart';
import 'package:nutrigains_front/screens/register_screen.dart';
import 'package:nutrigains_front/screens/user_MainScreen.dart';
import 'package:nutrigains_front/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
          lazy: false,
        ),

        // ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.€%%
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (_) => const LoginScreen(),
        'register': (_) => const RegisterScreen(),
        'userMainScreen': (_) => const userMainScreen(),
        'recipeScreen': (_) => const RecipeScreen(),
        'foodScreen': (_) => const FoodScreen(),
        'commentScreen': (_) => const CommentScreen(),
      },
      theme: ThemeData(
        canvasColor: Color.fromARGB(221, 34, 34, 34),
        cardColor:
            Color.fromARGB(255, 131, 131, 131), // Establece el cardColor global
      ),
    );
  }
}
