import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/widgets/custom_card_widget.dart';
import 'package:heychat/widgets/custom_elevated_button_widget.dart';
import 'package:heychat/widgets/custom_textfield_widget.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _username_controller = TextEditingController();
  final TextEditingController _password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        height: AppSizes.screenHeight(context),
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: AppSizes.screenWidth(context) - 5,
                child: SingleChildScrollView(
                  child: CustomCard(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingSmall),
                      child: Column(
                        children: [
                          loginForm(),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginForm(){
    return Column(
      children: [
        const SizedBox(height: AppSizes.paddingLarge,),

        //Kullanıcı adını al
        CustomTextfieldWidget(
          hint: AppStrings.enter_username,
          controller: _username_controller,
          prefixIcon: const Icon(Icons.person),
          keyboardType: TextInputType.text,
          isPassword: false,),
        const SizedBox(height: AppSizes.height,),

        //Şifreyi al
        CustomTextfieldWidget(
          hint: AppStrings.enter_password,
          controller: _password_controller,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: const Icon(Icons.remove_red_eye),
          isPassword: true,
          keyboardType: TextInputType.text,),
        const SizedBox(height: AppSizes.height,),

        //giriş yap butonu,
        CustomElevatedButtonWidget(
            text: AppStrings.login_button, onPressed: () {

        }),
        const SizedBox(height: AppSizes.height,),
        //ya da
        const Align(alignment:Alignment.center, child: Text(AppStrings.or)),
        const SizedBox(height: AppSizes.height,),
        Container(width: AppSizes.screenHeight(context),
          height: 2,
          color: Colors.black,),
        const SizedBox(height: AppSizes.height,),




        //kayıt ol butonu
        TextButton(onPressed: (){

        }, child: const Text(AppStrings.register_button)),
        const SizedBox(height: AppSizes.height,),

        //şifreyi sıfırla
        TextButton(onPressed: (){

        }, child: const Text(AppStrings.did_you_forget_your_password)),

      ],
    );
  }
}
