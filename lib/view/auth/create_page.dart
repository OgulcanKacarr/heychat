import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/view_model/auth/create_page_viewmodel.dart';
import 'package:heychat/widgets/custom_elevated_button_widget.dart';
import 'package:heychat/widgets/custom_textfield_widget.dart';

final view_model = ChangeNotifierProvider((ref) => CreatePageViewmodel());

class CreatePage extends ConsumerStatefulWidget {
  const CreatePage({super.key});

  @override
  ConsumerState<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends ConsumerState<CreatePage> {
  final TextEditingController _email_controller = TextEditingController();
  final TextEditingController _password_controller = TextEditingController();
  final TextEditingController _repassword_controller = TextEditingController();
  final TextEditingController _name_controller = TextEditingController();
  final TextEditingController _surname_controller = TextEditingController();
  final TextEditingController _username_controller = TextEditingController();
  final PageController pageController = PageController();
  int page_view_current_index = 0;

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(view_model);
    var read = ref.read(view_model);

    return Scaffold(
      body: Stack(
        children: [
          //geri oku
          Positioned(
              top: 20,
              left: 5,
              child:
              IconButton(onPressed: (){
                Navigator.pushReplacementNamed(context, "/login_page");
              }, icon: const Icon(Icons.arrow_back),)),
          _loginForm(read,watch),
        ],
      ),
    );
  }

  Widget _loginForm(var read, var watch){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: AppSizes.screenWidth(context) - 20,
            height: AppSizes.screenWidth(context) / 2,
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  page_view_current_index = index;
                });
              },
              children: [
                _buildNameSurnamePage(),
                _buildUsernameEmailPage(),
                _buildPasswordPage(),
              ],
            ),
          ),
          const SizedBox(height: 3),
          _buildPageIndicators(),
          const SizedBox(height: 15),
          CustomElevatedButtonWidget(
            text: pageController.hasClients && (page_view_current_index == 2)
                ? AppStrings.register_button
                : AppStrings.next_page,
            onPressed: () {
              if (pageController.hasClients) {
                int nextPage = pageController.page!.toInt() + 1;
                if (nextPage < 3) {
                  pageController.animateToPage(
                    nextPage,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Kayıt olma işlemini burada yapabilirsiniz
                }
              }
            },
          ),
          const SizedBox(height: 20),
          const Text(AppStrings.or),
          const SizedBox(height: 5),
          Container(width: AppSizes.screenWidth(context), height: 5, color: Colors.black,),
          const SizedBox(height: 2),
          TextButton(
            onPressed: () {
              read.goLoginPage(context);
            },
            child: const Text(AppStrings.login_button),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: page_view_current_index == index ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }



  Widget _buildNameSurnamePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(AppStrings.register_button,style: TextStyle(fontSize: AppSizes.paddingLarge, color: Colors.pinkAccent,fontWeight: FontWeight.bold),),
          const SizedBox(
            height: AppSizes.height,
          ),
          CustomTextfieldWidget(
            hint: AppStrings.name,
            controller: _name_controller,
            prefixIcon: const Icon(Icons.person),
            keyboardType: TextInputType.text,
            isPassword: false,
          ),
          const SizedBox(
            height: AppSizes.height,
          ),
          CustomTextfieldWidget(
            hint: AppStrings.surname,
            controller: _surname_controller,
            prefixIcon: const Icon(Icons.person),
            keyboardType: TextInputType.text,
            isPassword: false,
          ),
          const SizedBox(
            height: AppSizes.height,
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameEmailPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(AppStrings.register_button,style: TextStyle(fontSize: AppSizes.paddingLarge, color: Colors.pinkAccent,fontWeight: FontWeight.bold),),
          const SizedBox(
            height: AppSizes.height,
          ),
          CustomTextfieldWidget(
            hint: AppStrings.username,
            controller: _username_controller,
            prefixIcon: const Icon(Icons.person),
            keyboardType: TextInputType.text,
            isPassword: false,
          ),
          const SizedBox(
            height: AppSizes.height,
          ),
          CustomTextfieldWidget(
            hint: AppStrings.enter_email,
            controller: _email_controller,
            prefixIcon: const Icon(Icons.email),
            keyboardType: TextInputType.emailAddress,
            isPassword: false,
          ),
          const SizedBox(
            height: AppSizes.height,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(AppStrings.register_button,style: TextStyle(fontSize: AppSizes.paddingLarge, color: Colors.pinkAccent,fontWeight: FontWeight.bold),),
          const SizedBox(
            height: AppSizes.height,
          ),
          CustomTextfieldWidget(
            hint: AppStrings.enter_password,
            controller: _password_controller,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: const Icon(Icons.remove_red_eye),
            isPassword: true,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(
            height: AppSizes.height,
          ),
          CustomTextfieldWidget(
            hint: AppStrings.repassword,
            controller: _repassword_controller,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: const Icon(Icons.remove_red_eye),
            isPassword: true,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(
            height: AppSizes.height,
          ),
        ],
      ),
    );
  }
}
