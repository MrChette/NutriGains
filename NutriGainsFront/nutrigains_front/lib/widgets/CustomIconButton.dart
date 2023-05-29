import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  const CustomIconButton({
    Key? key,
    this.icon,
    this.label,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label ?? '',
            style: const TextStyle(
              color: Colors.black,
              // Otros estilos de texto
            ),
          ),
          if (icon != null) const SizedBox(width: 4),
          if (icon != null) Icon(icon, color: Colors.black),
        ],
      ),
    );
  }
}
