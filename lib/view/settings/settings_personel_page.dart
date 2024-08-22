import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/widgets/custom_app_bar_widget.dart';
import 'package:heychat/widgets/custom_elevated_button_widget.dart';
import 'package:heychat/widgets/custom_indicator_widget.dart';
import 'package:heychat/widgets/custom_textfield_widget.dart';

class SettingsPersonelPage extends ConsumerStatefulWidget {
  const SettingsPersonelPage({super.key});

  @override
  ConsumerState<SettingsPersonelPage> createState() =>
      _SettingsPersonelPageState();
}

class _SettingsPersonelPageState extends ConsumerState<SettingsPersonelPage> {
  late String title;
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    title = ModalRoute.of(context)?.settings.arguments as String;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: title,
        centerTitle: true,
        isBack: false,
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/settings_page");
        },
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              CachedNetworkImage(
                imageUrl: "https://avatars.githubusercontent.com/u/63792003?v=4",
                width: AppSizes.screenWidth(context),
                height: AppSizes.screenHeight(context) / 2.5,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Container(
                width: AppSizes.screenWidth(context),
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                // Profil fotoğrafı değiştirme işlevi
                              },
                              child: const Text(AppStrings.change_profile_photo)),
                          const SizedBox(height: 10),
                          TextButton(
                              onPressed: () {
                                // Kapak fotoğrafı değiştirme işlevi
                              },
                              child: const Text(AppStrings.change_cover_photo)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // İsim değiştirme Row'u
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextfieldWidget(
                                hint: AppStrings.name,
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                isPassword: false,
                                prefixIcon: const Icon(Icons.person)),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () {
                                // İsim değiştirme işlevi
                              },
                              child: const Text(AppStrings.change)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Kullanıcıadı değiştirme Row'u
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextfieldWidget(
                                hint: AppStrings.username,
                                controller: _usernameController,
                                keyboardType: TextInputType.text,
                                isPassword: false,
                                prefixIcon: const Icon(Icons.person)),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () {
                                // İsim değiştirme işlevi
                              },
                              child: const Text(AppStrings.change)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // email değiştirme Row'u
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextfieldWidget(
                                hint: AppStrings.enter_email,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                isPassword: false,
                                prefixIcon: const Icon(Icons.email)),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () {
                                // İsim değiştirme işlevi
                              },
                              child: const Text(AppStrings.change)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomElevatedButtonWidget(text: AppStrings.change_password, onPressed: (){

                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: AppSizes.screenHeight(context) / 2.5 - 50,
            left: (AppSizes.screenWidth(context) / 2) - 50,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  "https://github.com/OgulcanKacarr/OgulcanKacarr/raw/main/tr.png"),
            ),
          ),
        ],
      ),
    );
  }

}
