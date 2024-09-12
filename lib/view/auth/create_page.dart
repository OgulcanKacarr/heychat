import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/view_model/auth/create_page_viewmodel.dart';
import 'package:heychat/widgets/custom_card_widget.dart';
import 'package:heychat/widgets/custom_elevated_button_widget.dart';
import 'package:heychat/widgets/custom_indicator_widget.dart';
import 'package:heychat/widgets/custom_textfield_widget.dart';

final view_model = ChangeNotifierProvider((ref) => CreatePageViewmodel());

class CreatePage extends ConsumerStatefulWidget {
  const CreatePage({super.key});

  @override
  ConsumerState<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends ConsumerState<CreatePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  String _registerTitle = AppStrings.registerButton;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(view_model);
    final read = ref.read(view_model);

    return Scaffold(
      appBar: AppBar(
        title: Text(_registerTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, "/login_page"),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Center(
                    child: SizedBox(
                      height: AppSizes.screenWidth(context) / 2,
                      child: CustomCard(
                        child: _buildForm(viewModel, read),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPageIndicators(),
                  const SizedBox(height: 15),
                  CustomElevatedButtonWidget(
                    text: _currentPageIndex == 2
                        ? AppStrings.registerButton
                        : AppStrings.nextPage,
                    onPressed: () {
                      if (_pageController.hasClients) {
                        int nextPage = _pageController.page!.toInt() + 1;

                        if (nextPage < 3) {
                          _pageController.animateToPage(
                            nextPage,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          read.createUser(
                            context,
                            _nameController.text.trim(),
                            _surnameController.text.trim(),
                            _usernameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _repasswordController.text.trim(),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const Center(child: Text(AppStrings.or)),
                  const SizedBox(height: 10),
                  const CustomIndicatorWidget(),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: () => read.goLoginPage(context),
                    child: const Text(AppStrings.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(var viewModel, var read) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPageIndex = index;
          if (index == 0) {
            _registerTitle = AppStrings.registerButton;
          } else if (index == 1) {
            _registerTitle = AppStrings.registrationStep;
          } else if (index == 2) {
            _registerTitle = AppStrings.finalRegistrationStep;
          }
        });
      },
      children: [
        _buildNameSurnamePage(),
        _buildUsernameEmailPage(),
        _buildPasswordPage(),
      ],
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPageIndex == index ? Colors.pinkAccent : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildNameSurnamePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextfieldWidget(
            hint: AppStrings.name,
            controller: _nameController,
            prefixIcon: const Icon(Icons.person),
            keyboardType: TextInputType.text,
            isPassword: false,
          ),
          const SizedBox(height: 10),
          CustomTextfieldWidget(
            hint: AppStrings.surname,
            controller: _surnameController,
            prefixIcon: const Icon(Icons.person),
            keyboardType: TextInputType.text,
            isPassword: false,
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameEmailPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextfieldWidget(
            hint: AppStrings.username,
            controller: _usernameController,
            prefixIcon: const Icon(Icons.person),
            keyboardType: TextInputType.text,
            isPassword: false,
            useSpace: true,
          ),
          const SizedBox(height: 10),
          CustomTextfieldWidget(
            hint: AppStrings.enterEmail,
            controller: _emailController,
            prefixIcon: const Icon(Icons.email),
            keyboardType: TextInputType.emailAddress,
            isPassword: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextfieldWidget(
            hint: AppStrings.enterPassword,
            controller: _passwordController,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: const Icon(Icons.remove_red_eye),
            isPassword: true,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          CustomTextfieldWidget(
            hint: AppStrings.confirmPassword,
            controller: _repasswordController,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: const Icon(Icons.remove_red_eye),
            isPassword: true,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
