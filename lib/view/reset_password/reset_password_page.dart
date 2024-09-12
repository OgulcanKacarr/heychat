import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/widgets/custom_card_widget.dart';
import 'package:heychat/widgets/custom_elevated_button_widget.dart';
import 'package:heychat/widgets/custom_textfield_widget.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _email_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: AppSizes.screenWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //geri oku
              IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/login_page");
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Stack(
                children: [

                  Center(
                    child: CustomCard(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: AppSizes.paddingSmall,
                              ),

                              //Kullanıcı profil fotoğrafı
                              const Visibility(
                                visible: true,
                                child:  SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(AppStrings.logo),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: AppSizes.paddingLarge,
                              ),

                              //Kullanıcı emaili
                              CustomTextfieldWidget(
                                  hint: AppStrings.enterEmail,
                                  controller: _email_controller,
                                  keyboardType: TextInputType.emailAddress,
                                  isPassword: false,
                                  prefixIcon: const Icon(Icons.email)),
                              const SizedBox(
                                height: AppSizes.paddingSmall,
                              ),

                              //Arama butonu
                              CustomElevatedButtonWidget(
                                  text: AppStrings.search, onPressed: () {}),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
