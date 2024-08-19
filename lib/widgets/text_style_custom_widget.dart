import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextStyleCustomWidget{
  final Color color;
  TextStyleCustomWidget({required this.color});

   TextStyle style(){
      return TextStyle(
        color: color,
      );
  }
}
