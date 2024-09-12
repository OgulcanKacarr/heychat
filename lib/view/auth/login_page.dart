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
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(view_model);
    var read = ref.read(view_model);
    return Scaffold(
      body: _buildBody(context, watch,read),
    );
  }

  Widget _buildBody(BuildContext context, LoginPageViewmodel watch, LoginPageViewmodel read) {
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //Başlık
                          const Text(AppStrings.login,style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: AppSizes.paddingLarge,
                              fontWeight: FontWeight.bold
                          ), textAlign: TextAlign.center),
                          loginForm(context, watch),
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

  Widget loginForm(BuildContext context, LoginPageViewmodel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSizes.paddingLarge),

        // Email adresini al
        CustomTextfieldWidget(
          hint: AppStrings.enterEmail,
          controller: _email_controller,
          prefixIcon: const Icon(Icons.email),
          keyboardType: TextInputType.emailAddress,
          isPassword: false,
        ),
        const SizedBox(height: AppSizes.height),

        // Şifreyi al
        CustomTextfieldWidget(
          hint: AppStrings.enterPassword,
          controller: _password_controller,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          isPassword: !_isPasswordVisible,
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: AppSizes.height),

        // Giriş yap butonu
        CustomElevatedButtonWidget(
            text: AppStrings.login,
            onPressed: () {
              String email = _email_controller.text.trim();
              String password = _password_controller.text.trim();

              ref.read(view_model).loginButton(context, email, password);
            }
        ),

        const SizedBox(height: AppSizes.height),

        // Ya da
        const Align(alignment: Alignment.center, child: Text(AppStrings.or)),
        const SizedBox(height: AppSizes.height),
        const CustomIndicatorWidget(),
        const SizedBox(height: AppSizes.height),

        // Kayıt ol butonu
        TextButton(
            onPressed: () {
              ref.read(view_model).goRegisterPage(context);
            },
            child: const Text(AppStrings.registerButton)
        ),
        const SizedBox(height: AppSizes.height),

        // Şifre sıfırlama butonu
        TextButton(
            onPressed: () {
              ref.read(view_model).goResetPasswordPage(context);
            },
            child: const Text(AppStrings.did_you_forget_your_password)
        ),
      ],
    );
  }
}

