// ignore: file_names
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import '../models/food_model.dart';
import '../models/mealList_model.dart';
import '../models/meal_model.dart';
import '../services/auth_service.dart';
import '../services/food_service.dart';
import '../services/mealList_service.dart';
import '../services/meal_service.dart';

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
  final MealListService _mealListRepository = MealListService();
  final AuthService authService = AuthService();
  final String username = '';
  int _scanBarcode = 0;

  getUsername() async {
    String username = await authService.getUserName();
    print(username);
  }

  @override
  void initState() {
    super.initState();
    getUsername();
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
              customToast('Email or password incorrect', context);
            }
          },
        ),
      ),
    );
  }

  @override
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
      //AQUI AÑADIMOS LOS OBJETOS PARA LA PANTALLA //
      body: Column(
        children: [
          const SizedBox(height: 30.0),
          addMealButton(context),
        ],
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
                      title: Text("ADD MEAL"),
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

@override
Widget addFoodButton(BuildContext context) {
  return SizedBox(
      child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 35.0),
    width: MediaQuery.of(context).size.width * 1,
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

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.black,
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          // Otros estilos de texto
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.amber[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shadowColor: Colors.black,
        onPrimary: Colors.amber[900],
        textStyle: const TextStyle(fontSize: 16),
        padding: padding,
        animationDuration: const Duration(milliseconds: 100),
      ),
    );
  }
}
