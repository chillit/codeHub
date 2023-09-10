import 'package:flutter/material.dart';

class RectangularButton extends StatelessWidget {
  const RectangularButton({
    key,
    this.onPressed,
    this.label,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF7e4a3b), // Установите цвет фона кнопки
        shadowColor: Colors.black, // Установите цвет тени
        elevation: 5, // Установите высоту тени
      ),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              letterSpacing: 2,
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Colors.white, // Установите цвет текста кнопки
            ),
          ),
        ),
      ),
    );
  }
}