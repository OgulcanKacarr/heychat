import 'package:flutter/material.dart';
import 'package:heychat/constants/AppSizes.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  String title;
  bool center_title;
  Color color;
  bool isBack;

  CustomAppBarWidget(
      {super.key,
      required this.title,
      this.center_title = false,
      this.color = Colors.black,
      this.isBack = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: AppSizes.paddingMedium, color: Colors.pinkAccent),
      ),
      centerTitle: center_title,
      backgroundColor: color,
      iconTheme: const IconThemeData(color: Colors.red),
      automaticallyImplyLeading: isBack,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
