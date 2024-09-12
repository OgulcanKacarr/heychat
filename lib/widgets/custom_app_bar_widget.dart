import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppColors.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/services/shared_pref_service.dart';
import 'package:heychat/view_model/home_page_viewmodel.dart';

class CustomAppBarWidget extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color background;
  final bool isBack;
  final bool actions;
  final VoidCallback? onPressed;


  CustomAppBarWidget({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.background = AppColors.app_bar_background,
    this.isBack = false,
    this.actions = false,
    this.onPressed,
  });

  @override
  ConsumerState<CustomAppBarWidget> createState() => _CustomAppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

final view_model = ChangeNotifierProvider((ref)=> HomePageViewmodel());
class _CustomAppBarWidgetState extends ConsumerState<CustomAppBarWidget> {
  late Future<Color?> _colorFuture;

  @override
  void initState() {
    super.initState();
    _colorFuture = _loadColors();
  }

  Future<Color?> _loadColors() async {
    final appbarColors = await SharedPrefService.read("appbar_colors");
    if (appbarColors != null && appbarColors.isNotEmpty) {
      return Color(int.parse(appbarColors[0]));
    }
    return null; // Default color if no color is saved
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Color?>(
      future: _colorFuture,
      builder: (context, snapshot) {
        Color appBarColor = snapshot.data ?? AppColors.app_bar_background;

        return AppBar(
          backgroundColor: appBarColor,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.paddingLarge,
            ),
          ),
          centerTitle: widget.centerTitle,
          leading: widget.isBack
              ? const Icon(
            Icons.apple,
            color: Colors.white,
          )
              : IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: widget.onPressed,
          ),
          actions: widget.actions
              ? [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (String result) {
                switch (result) {
                  case "post":
                    Navigator.pushReplacementNamed(context, "/feed_page");
                    break;
                  case "requests":
                    Navigator.pushReplacementNamed(context, "/request_page");

                    break;
                  case "settings":
                    Navigator.pushReplacementNamed(context, "/settings_page");
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'post',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.add),
                      const SizedBox(width: 5,),
                      Text(AppStrings.add),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'requests',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.notification_important),
                      const SizedBox(width: 5,),
                      Text(AppStrings.requests),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.settings),
                      const SizedBox(width: 5,),
                      Text(AppStrings.appSettings),
                    ],
                  ),
                ),
              ],
            ),
          ]
              : null,
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
