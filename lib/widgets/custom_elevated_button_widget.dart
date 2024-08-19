import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomElevatedButtonWidget extends StatelessWidget {
  String text;
  VoidCallback  onPressed;
  CustomElevatedButtonWidget({required this.text, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green
        ),
        child: Text(text));
  }
}
