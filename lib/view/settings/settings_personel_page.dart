import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/view_model/settings/settings_page_personel_viewmodel.dart';
import 'package:heychat/widgets/custom_app_bar_widget.dart';
import 'package:heychat/widgets/custom_elevated_button_widget.dart';
import 'package:heychat/widgets/custom_textfield_widget.dart';

final viewModelProvider = ChangeNotifierProvider<SettingsPagePersonelViewmodel>(
    (ref) => SettingsPagePersonelViewmodel());

class SettingsPersonelPage extends ConsumerStatefulWidget {
  const SettingsPersonelPage({super.key});

  @override
  ConsumerState<SettingsPersonelPage> createState() =>
      _SettingsPersonelPageState();
}

class _SettingsPersonelPageState extends ConsumerState<SettingsPersonelPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConstMethods _constMethods = ConstMethods();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _bioilController;

  //kullanıcı bilgilerini getir
  late Future<Users?> _getUsers;


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _bioilController = TextEditingController();
    _getUsers = _getUserInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _bioilController.dispose();
    super.dispose();
  }


  //Kullanıcıları veritabanından çek
  Future<Users?> _getUserInfo() async {
    Users? user = await _constMethods.getUserInfo(context,_auth.currentUser!.uid);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(viewModelProvider);
    var read = ref.read(viewModelProvider);

    return Scaffold(
      appBar: CustomAppBarWidget(
        title:  AppStrings.personalSettings,
        centerTitle: true,
        isBack: false,
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/settings_page");
        },
      ),
      body: FutureBuilder(
        future: _getUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Hata: ${snapshot.error}");
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text(AppStrings.userNotFound));
          } else {
            //kullanıcı bilgileri değişkenlere işle
            Users user = snapshot.data!;


            return _buildBody(watch, read, user);
          }
        },
      ),
    );
  }

  Widget _buildBody(
      SettingsPagePersonelViewmodel watch, SettingsPagePersonelViewmodel read, Users user) {
    return SingleChildScrollView(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              // Kapak Fotoğrafı Tasarımı
              SizedBox(
                width: AppSizes.screenWidth(context),
                height: AppSizes.screenHeight(context) / 2.5,
                child: user.coverImageUrl.isEmpty
                    ? const Center(
                        child: Text(AppStrings.coverPhotoNotFound))
                    : _constMethods.showCachedImage(user.coverImageUrl),
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
                              onPressed: () async {
                                // Profil fotoğrafı değiştirme işlevi
                                setState(() async {
                                  await watch.updateProfilePhoto(context);
                                });

                              },
                              child:
                                  const Text(AppStrings.changeProfilePhoto)),
                          const SizedBox(height: 10),
                          TextButton(
                              onPressed: () async {
                                // Kapak fotoğrafı değiştirme işlevi
                                setState(() async {
                                  await watch.updateCoverPhoto(context);
                                });

                              },
                              child: const Text(AppStrings.changeCoverPhoto)),
                        ],
                      ),
                      //fotoğrafları silme butonları
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () async {
                                // Profil fotoğrafı silme işlevi
                                await watch.updateProfilePhoto(context);
                              },
                              icon:
                                  const Icon(Icons.delete,color: Colors.teal,)),
                          const SizedBox(height: 10),
                          IconButton(
                              onPressed: () async {
                                // Kapak fotoğrafı silme işlevi
                                await _constMethods.removeCoverPhoto(context);

                              },
                              icon:
                              const Icon(Icons.delete,color: Colors.green,)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // İsim değiştirme Row'u
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextfieldWidget(
                                hint: user.displayName,
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                isPassword: false,
                                useSpace: true,
                                prefixIcon: const Icon(Icons.person)),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () async {
                                // İsim değiştirme işlevi
                                read.updateNameAndSurname(
                                    context, _nameController.text);
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
                                hint: user.username,
                                controller: _usernameController,
                                keyboardType: TextInputType.text,
                                isPassword: false,
                                prefixIcon: const Icon(Icons.person)),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () {
                                // İsim değiştirme işlevi
                                read.updateUsername(
                                    context, _usernameController.text);
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
                                hint: user.email,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                isPassword: false,
                                prefixIcon: const Icon(Icons.email)),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () {
                                // İsim değiştirme işlevi
                                read.updateEmail(
                                    context, _emailController.text);
                              },
                              child: const Text(AppStrings.change)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // bio değiştirme Row'u
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextfieldWidget(
                                hint: user.bio.isNotEmpty ? user.bio : AppStrings.bio,
                                controller: _bioilController,
                                keyboardType: TextInputType.text,
                                isPassword: false,
                                useSpace: true,
                                prefixIcon: const Icon(Icons.person)),
                          ),

                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () {
                                // İsim değiştirme işlevi
                                read.updateBio(
                                    context, _bioilController.text);
                              },
                              child: const Text(AppStrings.change)),
                        ],
                      ),

                      //Şifre Değişitrme butonu
                      const SizedBox(height: 10),
                      CustomElevatedButtonWidget(
                          text: AppStrings.changePassword,
                          onPressed: () {
                            changePasswordAlertDialog(context);
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Profil Fotoğrafı Tasarımı
          Positioned(
            top: AppSizes.screenHeight(context) / 2.5 - 50,
            left: (AppSizes.screenWidth(context) / 2) - 50,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200], // Opsiyonel: Arka plan rengi
              child: user.profileImageUrl.isEmpty
                  ? const Icon(Icons.person, size: 50) // Profil fotoğrafı yoksa ikon göster
                  : ClipOval(
                child: _constMethods.showCachedImage(
                  user.profileImageUrl,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  //şifre değiştirme dialoğu
  void changePasswordAlertDialog(BuildContext context) {
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController reNewPasswordController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: const Center(child: Text(AppStrings.changePassword)),
              content: SizedBox(
                width: AppSizes.screenWidth(context),
                height: AppSizes.screenWidth(context) / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: newPasswordController,
                      decoration: const InputDecoration(
                        hintText: AppStrings.newPassword,
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.paddingSmall,
                    ),
                    TextField(
                      controller: reNewPasswordController,
                      decoration: const InputDecoration(
                        hintText: AppStrings.confirmNewPassword,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(AppStrings.cancel)),

                // Şifre değiştir
                TextButton(
                  onPressed: () async {
                    String? newPassword = newPasswordController.text;
                    String? reNewPassword = reNewPasswordController.text;

                    if (newPassword.isEmpty) {
                      ShowSnackBar.show(context, AppStrings.newPassword);
                      return;
                    }

                    if (reNewPassword.isEmpty) {
                      ShowSnackBar.show(context, AppStrings.confirmPassword);
                      return;
                    }

                    await ref.read(viewModelProvider).updatePassword(
                        context,newPassword, reNewPassword);
                  },
                  child: const Text(AppStrings.change),
                ),
              ],
            ),
          );
        });
  }

}
