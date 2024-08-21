import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppColors.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/view_model/home_page_viewmodel.dart';
import 'package:heychat/widgets/custom_navigationbar_widget.dart';

final viewModelProvider = ChangeNotifierProvider<HomePageViewmodel>((ref) => HomePageViewmodel());

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final watch = ref.watch(viewModelProvider);
    final read = ref.read(viewModelProvider);

    return Scaffold(
      //appbar'ı göstermek istediğimiz yerlerde göster
      appBar: watch.showAppBar ? _buildAppBar(watch.title) : null,
      bottomNavigationBar: const CustomNavigationbarWidget(),
      body: watch.buildBody(),
    );
  }

  AppBar _buildAppBar(String title) {
    final read = ref.read(viewModelProvider);
    return AppBar(
      backgroundColor: AppColors.app_bar_background,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppSizes.paddingLarge,
        ),
      ),
      centerTitle: true,
      leading: const Icon(
        Icons.apple,
        color: Colors.white,
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (String result) {
            switch (result) {
              case "post":

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
              value: 'settings',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.settings),
                  const SizedBox(width: 5,),
                  Text(AppStrings.settings),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
