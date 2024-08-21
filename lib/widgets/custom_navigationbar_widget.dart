import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppColors.dart';
import 'package:heychat/services/shared_pref_service.dart';
import 'package:heychat/view/nav/home_page.dart';

class CustomNavigationbarWidget extends ConsumerStatefulWidget {
  final Color? initialSelectedItemColor;
  final Color? initialUnselectedItemColor;

  CustomNavigationbarWidget({
    this.initialSelectedItemColor,
    this.initialUnselectedItemColor,
  });

  @override
  ConsumerState<CustomNavigationbarWidget> createState() => _CustomNavigationbarWidgetState();
}

class _CustomNavigationbarWidgetState extends ConsumerState<CustomNavigationbarWidget> {
  Color selectedItemColor = AppColors.selected_item_color;
  Color unselectedItemColor = AppColors.un_selected_item_color;

  late Future<void> _colorFuture;

  @override
  void initState() {
    super.initState();
    _colorFuture = _loadColors();
  }

  Future<void> _loadColors() async {
    final navColors = await SharedPrefService.read("nav_colors");
    if (navColors != null && navColors.isNotEmpty) {
      setState(() {
        selectedItemColor = Color(int.parse(navColors[0]));
        unselectedItemColor = Color(int.parse(navColors[1]));
      });
    } else {
      // Use default colors if no colors are found
      setState(() {
        selectedItemColor = widget.initialSelectedItemColor ?? selectedItemColor;
        unselectedItemColor = widget.initialUnselectedItemColor ?? unselectedItemColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final watch = ref.watch(viewModelProvider);

    return FutureBuilder(
      future: _colorFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return BottomNavigationBar(
            items: watch.items,
            currentIndex: watch.bottom_nav_current_index,
            selectedItemColor: selectedItemColor,
            unselectedItemColor: unselectedItemColor,
            onTap: (index) {
              watch.setCurrentIndex(index);
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
