import 'package:flutter/cupertino.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService{

  static Future<void> save(BuildContext context, String name, List<String> data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList(name, data);
    ShowSnackBar.show(context, AppStrings.applySettings);
  }

  static Future<List<String>?> read(String name) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? colors = await sharedPreferences.getStringList(name);
    return colors;
  }

}