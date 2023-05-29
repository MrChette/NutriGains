import 'package:flutter/material.dart';

class GenericBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GenericBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<GenericBottomNavigationBar> createState() =>
      _GenericBottomNavigationBarState();
}

class _GenericBottomNavigationBarState
    extends State<GenericBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: widget.currentIndex,
      //? PARA QUE SE MUESTRE EL LABEL
      //showUnselectedLabels: true,
      onTap: widget.onTap,
      selectedItemColor: Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Recips',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.food_bank),
          label: 'Foods',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Social',
        ),
      ],
    );
  }
}
