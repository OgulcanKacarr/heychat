import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/view_model/auth/login_page_viewmodel.dart';
import 'package:heychat/widgets/custom_card_widget.dart';
import 'package:heychat/widgets/custom_elevated_button_widget.dart';
import 'package:heychat/widgets/custom_indicator_widget.dart';
import 'package:heychat/widgets/custom_textfield_widget.dart';

final view_model = ChangeNotifierProvider((ref) => LoginPageViewmodel());
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _email_controller = TextEditingController();
  final TextEditingController _password_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var read = ref.read(view_model);
    var watch = ref.watch(view_model);
    return Scaffold(
      body: _buildBody(read,watch),
    );
  }

  Widget _buildBody(var read, var watch) {
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
                          //Başlık
                          const Text(AppStrings.login_title,style: TextStyle(
                             color: Colors.pinkAccent,
                             fontSize: AppSizes.paddingLarge,
                             fontWeight: FontWeight.bold
                           ),),
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

        //email adresini al
        CustomTextfieldWidget(
          hint: AppStrings.enter_email,
          controller: _email_controller,
          prefixIcon: const Icon(Icons.email),
          keyboardType: TextInputType.emailAddress,
          isPassword: false,),
        const SizedBox(height: AppSizes.height,),

        //Şifreyi al
        CustomTextfieldWidget(
          hint: AppStrings.enter_password,
          controller: _password_controller,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: const Icon(Icons.remove_red_eye),
          isPassword: true,
          useSpace: true,
          keyboardType: TextInputType.text,),
        const SizedBox(height: AppSizes.height,),

        //giriş yap butonu,
        CustomElevatedButtonWidget(
            text: AppStrings.login_button, onPressed: () {
              String email = _email_controller.text.trim();
              String password = _password_controller.text.trim();

            ref.read(view_model).loginButton(context,email, password);
        }),

        const SizedBox(height: AppSizes.height,),
        //ya da
        const Align(alignment:Alignment.center, child: Text(AppStrings.or)),
        const SizedBox(height: AppSizes.height,),
        const CustomIndicatorWidget(),
        const SizedBox(height: AppSizes.height,),


        //kayıt ol butonu
        TextButton(onPressed: (){
            ref.read(view_model).goRegisterPage(context);
        }, child: const Text(AppStrings.register_button)),
        const SizedBox(height: AppSizes.height,),

        //şifre sıfırlama butonu
        TextButton(onPressed: (){
          ref.read(view_model).goResetPasswordPage(context);
        }, child: const Text(AppStrings.did_you_forget_your_password)),

      ],
    );
  }
}
