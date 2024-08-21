import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppColors.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/services/shared_pref_service.dart';
import 'package:heychat/view_model/settings_feed_page_viewmodel.dart';
import 'package:heychat/widgets/custom_app_bar_widget.dart';
import 'package:heychat/widgets/custom_indicator_widget.dart';
import 'package:heychat/widgets/custom_navigationbar_widget.dart';

final view_model = ChangeNotifierProvider((ref)=> SettingsFeedPageViewmodel());
class SettingsFeedPage extends ConsumerStatefulWidget {

   SettingsFeedPage({super.key,});

  @override
  ConsumerState<SettingsFeedPage> createState() => _SettingsFeedPageState();
}

class _SettingsFeedPageState extends ConsumerState<SettingsFeedPage> {
  late String title;

  //nav colors
  Color selectedItemColor = AppColors.selected_item_color;
  Color unselectedItemColor = AppColors.un_selected_item_color;
  //appbar color
  Color appbar_custom_color = AppColors.app_bar_background;

  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //sayfa başlığını bir önceki sayfadan al
    title = ModalRoute.of(context)?.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: title, centerTitle: true,isBack: false,onPressed: (){
        Navigator.pushReplacementNamed(context, "/settings_page");
      },),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    var watch = ref.watch(view_model);
    var read = ref.read(view_model);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Column(
          children: [
            //altbar ayarları
            _navbarSettings(),
            //view
            CustomIndicatorWidget(),
            //appbar ayarları
            _buildAppbarSettings(),
          ],
        ),
      ),
    );
  }


  //navbar settings
  Widget _navbarSettings(){
    return Column(
      children: [
        const Text(AppStrings.app_alt_bar_color_settings,style: TextStyle(fontSize: AppSizes.paddingMedium),),
        Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child:CircleAvatar(backgroundColor: selectedItemColor,),
                ),
                const SizedBox(height: 3),
                // Renk seçme butonu
                ElevatedButton(
                  onPressed: () => _pickColor(context,selectedItemColor),
                  child: const Text(AppStrings.selected_color),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child:CircleAvatar(backgroundColor: unselectedItemColor,),
                ),
                const SizedBox(height: 3),
                // Renk seçme butonu
                ElevatedButton(
                  onPressed: () => _pickColor(context,unselectedItemColor),
                  child: const Text(AppStrings.unselected_color),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10,),
        CustomNavigationbarWidget(),
        const SizedBox(height: 15,),
        //navigationbar için kayıt butonu
        TextButton(onPressed: (){

          //nav color renklerini kaydet.
          String selectedItemColor_ =  selectedItemColor.value.toString();
          String unselectedItemColor_ =   unselectedItemColor.value.toString();
          List<String> nav_colors = [
            selectedItemColor_,
            unselectedItemColor_
          ];
          SharedPrefService.save(context, "nav_colors", nav_colors);
          setState(() {

          });
        }, child: const Text(AppStrings.apply)),

      ],
    );
  }

  //appbar settings
  Widget _buildAppbarSettings(){
    return Column(
      children: [
        const SizedBox(height: 20,),
        const Text(AppStrings.app_app_bar_color_settings,style: TextStyle(fontSize: AppSizes.paddingMedium),),
        const SizedBox(height: 10,),
        Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child:CircleAvatar(backgroundColor: appbar_custom_color,),
            ),
            const SizedBox(height: 3),
            // Renk seçme butonu
            ElevatedButton(
              onPressed: () => _pickColor(context,appbar_custom_color),
              child: const Text(AppStrings.selected_color),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        CustomAppBarWidget(title: AppStrings.appName, isBack: true,centerTitle: true,background: appbar_custom_color,),
        const SizedBox(height: 10,),
        TextButton(onPressed: (){

          //appbar color rengini kaydet.
          String appbar_color = appbar_custom_color.value.toString();
          List<String> appbar_colors = [
            appbar_color
          ];
          SharedPrefService.save(context, "appbar_colors", appbar_colors);
          setState(() {

          });
        }, child: const Text(AppStrings.apply)),
      ],
    );
  }

  //renk skalası
  void _pickColor(BuildContext context, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.choose_color),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: (color) {
              setState(() {
                color = color;
              });
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text(AppStrings.select),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

}
