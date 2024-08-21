import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppColors.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/view_model/settings_page_viewmodel.dart';

final view_model = ChangeNotifierProvider((ref) => SettingsPageViewmodel());

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  //ayarlar sayfasındaki butonlar
  List<String> settings_buttons = [
    "Kişisel ayarlar",
    "Bildirimler",
  ];

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(view_model);
    var read = ref.read(view_model);
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
      bottomNavigationBar: TextButton(
        onPressed: () async {
          //uygulamadan çıkış yap
          await read.logout(context);
        },
        child: const Text(
          AppStrings.exit,
          style: TextStyle(
              fontSize: AppSizes.paddingMedium,
              fontWeight: FontWeight.bold,
              color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
              itemCount: settings_buttons.length,
              itemBuilder: buttons,
            ),
          ),
        )
      ],
    );
  }

  //butonlar
  Widget buttons(BuildContext context, int index){
    return ListTile(
      title: Text(settings_buttons[index]),
      trailing: const Icon(Icons.arrow_right),
      onTap: () {
        // Burada butona tıklama işlemini tanımlayın
      },
    );

  }

  //appbar
  AppBar _buildAppbar(){
    return AppBar(
      backgroundColor: AppColors.app_bar_background,
      title: const Text(
        AppStrings.settings,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppSizes.paddingLarge,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/home_page");
        },
      ),
    );
  }
}
