import 'package:flutter/cupertino.dart';

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 12.0;
  static const double height = 10.0;

  static double screenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
  static double screenHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

}
