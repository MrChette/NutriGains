// ignore: file_names
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../models/mealList_model.dart';
import '../models/meal_model.dart';
import '../services/auth_service.dart';
import '../services/mealList_service.dart';
import '../services/meal_service.dart';

class userMainScreen extends StatefulWidget {
  const userMainScreen({Key? key}) : super(key: key);

  @override
  State<userMainScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<userMainScreen> {
  final MealListService _mealListRepository = MealListService();
  final AuthService authService = AuthService();
  int _selectedIndex = 0;

  Future<String> getUserName() async {
    return authService.getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopBar(getUserName: authService.getUserName),
              PromoCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          // ...
          ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  IconBottomBar(
      {Key? key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: selected ? const Color(0xff15BE77) : Colors.grey,
          ),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 14,
              height: .1,
              color: selected ? const Color(0xff15BE77) : Colors.grey),
        )
      ],
    );
  }
}

class TopBar extends StatefulWidget {
  final Future<String> Function() getUserName;
  TopBar({Key? key, required this.getUserName}) : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  List<MealModel>? _meals;
  final MealService _mealService = MealService();

  @override
  void initState() {
    super.initState();
    _initMeals();
  }

  Future<void> _initMeals() async {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    _meals = await _mealService.getMealByDate(formattedDate);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: widget.getUserName(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  "Hi ${snapshot.data}!",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "You have ${_meals?.length} meals today.",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

//class SearchInput extends StatelessWidget {
//  const SearchInput({Key? key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding:
//          const EdgeInsets.only(top: 8.0, left: 25.0, right: 25.0, bottom: 8.0),
//      child: Container(
//        decoration: BoxDecoration(boxShadow: [
//          BoxShadow(
//              offset: const Offset(12, 26),
//              blurRadius: 50,
//              spreadRadius: 0,
//              color: Colors.grey.withOpacity(.1)),
//        ]),
//        child: TextField(
//          onChanged: (value) {
//            //Do something wi
//          },
//          decoration: const InputDecoration(
//            prefixIcon: Icon(Icons.search),
//            filled: true,
//            fillColor: Colors.white,
//            hintText: 'Search',
//            hintStyle: TextStyle(color: Colors.grey),
//            contentPadding:
//                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//            border: OutlineInputBorder(
//              borderRadius: BorderRadius.all(Radius.circular(15.0)),
//            ),
//            enabledBorder: OutlineInputBorder(
//              borderSide: BorderSide(color: Colors.white, width: 1.0),
//              borderRadius: BorderRadius.all(Radius.circular(15.0)),
//            ),
//            focusedBorder: OutlineInputBorder(
//              borderSide: BorderSide(color: Colors.white, width: 2.0),
//              borderRadius: BorderRadius.all(Radius.circular(15.0)),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}

class PromoCard extends StatelessWidget {
  const PromoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 500,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
                colors: [Color(0xff53E88B), Color(0xff15BE77)])),
        child: Stack(
          children: const [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(25.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//class Headline extends StatelessWidget {
//  const Headline({Key? key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: EdgeInsets.only(left: 25.0, right: 25.0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: [
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: const [
//              Text(
//                "Nearest Restaurants",
//                style: TextStyle(
//                    color: Colors.black,
//                    fontSize: 18,
//                    fontWeight: FontWeight.normal),
//              ),
//              Text(
//                "The best food close to you",
//                style: TextStyle(
//                    color: Colors.grey,
//                    fontSize: 12,
//                    fontWeight: FontWeight.normal),
//              ),
//            ],
//          ),
//          const Text(
//            "View More",
//            style: TextStyle(
//                color: Color(0xff15BE77), fontWeight: FontWeight.normal),
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//class SHeadline extends StatelessWidget {
//  const SHeadline({Key? key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: EdgeInsets.only(left: 25.0, right: 25.0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: [
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Text(
//                "Popular Menu",
//                style: TextStyle(
//                    color: Colors.black,
//                    fontSize: 18,
//                    fontWeight: FontWeight.normal),
//              ),
//              Text(
//                "The best food for you",
//                style: TextStyle(
//                    color: Colors.grey,
//                    fontSize: 12,
//                    fontWeight: FontWeight.normal),
//              ),
//            ],
//          ),
//          Text(
//            "View More",
//            style: TextStyle(
//                color: Color(0xff15BE77), fontWeight: FontWeight.normal),
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//class CardListView extends StatelessWidget {
//  const CardListView({Key? key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.only(top: 25.0, right: 25.0, bottom: 15.0),
//      child: SizedBox(
//        width: MediaQuery.of(context).size.width,
//        height: 175,
//        child: ListView(
//          scrollDirection: Axis.horizontal,
//          children: [
//            Card(
//                "Vegan",
//                "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/Resturant%20Image%20(1).png?alt=media&token=461162b1-686b-4b0e-a3ee-fae1cb8b5b33",
//                "8 min away"),
//            Card(
//                "Italian ",
//                "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/Restaurant%20Image.png?alt=media&token=43509b4c-269e-4279-8c88-36dc9ed27a66",
//                "12 min away"),
//            Card(
//                "Vegan",
//                "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/Resturant%20Image%20(1).png?alt=media&token=461162b1-686b-4b0e-a3ee-fae1cb8b5b33",
//                "15 min away"),
//          ],
//        ),
//      ),
//    );
//  }
//}

class Card extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String subtitle;

  Card(this.text, this.imageUrl, this.subtitle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, bottom: 15),
      child: Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(10, 20),
                blurRadius: 10,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.05)),
          ],
        ),
        child: Column(
          children: [
            Image.network(imageUrl, height: 70, fit: BoxFit.cover),
            Spacer(),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(
              height: 5,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 12),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class getUsername {
  Future<String> someMethod() async {
    AuthService authService = AuthService();
    String userName = await authService.getUserName();
    print(userName);
    return userName;
  }
}
