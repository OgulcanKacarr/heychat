import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/widgets/custom_app_bar_widget.dart';

class SettingsPersonelPage extends ConsumerStatefulWidget {
  const SettingsPersonelPage({super.key});

  @override
  ConsumerState<SettingsPersonelPage> createState() => _SettingsPersonelPageState();
}

class _SettingsPersonelPageState extends ConsumerState<SettingsPersonelPage> {

  late String title;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //sayfa başlığını bir önceki sayfadan al
    title = ModalRoute.of(context)?.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: CustomAppBarWidget(title: title,centerTitle: true,isBack: false, onPressed: (){
        Navigator.pushReplacementNamed(context, "/settings_page");
      },),
      body: _buildBody(),
    );
  }
  Widget _buildBody(){
    return Column(
      children: [

      ],
    );
  }
}
