import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppColors.dart';
import 'package:heychat/constants/AppLifecycleObserver.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/services/firebase_auth_service.dart';
import 'package:heychat/view_model/home_page_viewmodel.dart';
import 'package:heychat/widgets/custom_app_bar_widget.dart';
import 'package:heychat/widgets/custom_navigationbar_widget.dart';

final viewModelProvider = ChangeNotifierProvider<HomePageViewmodel>((ref) => HomePageViewmodel());

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState();

  }




  @override
  Widget build(BuildContext context) {
    final watch = ref.watch(viewModelProvider);

    return Scaffold(
      //appbar'ı göstermek istediğimiz yerlerde göster
      appBar: watch.showAppBar ? CustomAppBarWidget(
          title: watch.title,
      isBack: true,
      centerTitle: true,
      actions: true) : null,
      bottomNavigationBar:  CustomNavigationbarWidget(),
      body: watch.buildBody(),
    );
  }


}
