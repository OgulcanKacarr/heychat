import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppColors.dart';
import 'package:heychat/services/shared_pref_service.dart';
import 'package:heychat/view/nav/home_page.dart';

class CustomFloatingactionbuttonWidget extends ConsumerStatefulWidget {
  final Color? background;
  final Color? foreground;

  CustomFloatingactionbuttonWidget({
    this.background,
    this.foreground,
  });

  @override
  ConsumerState<CustomFloatingactionbuttonWidget> createState() => _CustomNavigationbarWidgetState();
}

class _CustomNavigationbarWidgetState extends ConsumerState<CustomFloatingactionbuttonWidget> {
  Color foreground = AppColors.selected_item_color;
  Color background = AppColors.un_selected_item_color;

  late Future<void> _colorFuture;

  @override
  void initState() {
    super.initState();
    _colorFuture = _loadColors();
  }

  Future<void> _loadColors() async {
    final navColors = await SharedPrefService.read("floating_button_colors");
    if (navColors != null && navColors.isNotEmpty) {
      setState(() {
        background = Color(int.parse(navColors[0]));
        foreground = Color(int.parse(navColors[1]));
      });
    } else {
      // Use default colors if no colors are found
      setState(() {
        background = widget.background ?? background;
        foreground = widget.foreground ?? foreground;
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
          return FloatingActionButton(
            backgroundColor:  background,
            onPressed: (){

            },
            child:  Icon(Icons.add,color: foreground,),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
