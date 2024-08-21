import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppColors.dart';
import 'package:heychat/view/nav/home_page.dart';
import 'package:heychat/view_model/home_page_viewmodel.dart';

class CustomNavigationbarWidget extends ConsumerStatefulWidget {
  const CustomNavigationbarWidget({super.key});

  @override
  ConsumerState<CustomNavigationbarWidget> createState() => _CustomNavigationbarWidgetState();
}

class _CustomNavigationbarWidgetState extends ConsumerState<CustomNavigationbarWidget> {
  @override
  Widget build(BuildContext context) {
    final watch = ref.watch(viewModelProvider);

    return BottomNavigationBar(
      items: watch.items,
      currentIndex: watch.bottom_nav_current_index,
      selectedItemColor: AppColors.selected_item_color,
      unselectedItemColor: AppColors.un_selected_item_color,
      onTap: (index) {
        watch.setCurrentIndex(index);
      },
    );
  }
}
