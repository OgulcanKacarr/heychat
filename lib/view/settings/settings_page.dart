import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppColors.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/view_model/settings_page_viewmodel.dart';
import 'package:heychat/widgets/custom_app_bar_widget.dart';

final view_model = ChangeNotifierProvider((ref) => SettingsPageViewmodel());

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  //ayarlar sayfasındaki butonlar
  List<String> settings_buttons = [
    AppStrings.personal_settings,
    AppStrings.app_settings,
    AppStrings.notification_settings,
  ];

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(view_model);
    var read = ref.read(view_model);
    return Scaffold(
      appBar: CustomAppBarWidget(title: AppStrings.settings,isBack: false, centerTitle: true,onPressed:(){
        Navigator.pushReplacementNamed(context, "/home_page");
      }),
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
        // settings_feed page'e git
        if(settings_buttons[index] == AppStrings.app_settings){
          Navigator.pushReplacementNamed(context, "/settings_feed_page", arguments: settings_buttons[index]);
        }

      },
    );

  }


}
