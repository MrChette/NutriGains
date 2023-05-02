import 'package:flutter/material.dart';
import 'package:frontspring/screens/category_screen.dart';
import 'package:frontspring/screens/favProducts_screen.dart';
import 'package:frontspring/screens/login_screen.dart';
import 'package:frontspring/screens/product_screen.dart';
import 'package:frontspring/screens/register_screen.dart';
import 'package:frontspring/screens/userProduct_screen.dart';
import 'package:frontspring/services/auth_service.dart';
import 'package:frontspring/services/category_service.dart';
import 'package:frontspring/services/product_service.dart';
import 'package:frontspring/services/verify_service.dart';
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
        ChangeNotifierProvider(
          create: (_) => VerifyService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductService(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryService(),
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
          'adminProducts': (_) => const ProductScreen(),
          'adminCategory': (_) => const CategoryScreen(),
          'userProducts': (_) => const userProductScreen(),
          'favProducts': (_) => const favProductScreen(),
        });
  }
}
