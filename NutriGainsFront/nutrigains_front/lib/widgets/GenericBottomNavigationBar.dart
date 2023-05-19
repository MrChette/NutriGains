import 'package:flutter/material.dart';

class GenericBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GenericBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _GenericBottomNavigationBarState createState() =>
      _GenericBottomNavigationBarState();
}

class _GenericBottomNavigationBarState
    extends State<GenericBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
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
      ],
    );
  }
}
