import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/view_model/profile_page_viewmodel.dart';
import 'package:heychat/widgets/custom_elevated_button_widget.dart';
import 'package:heychat/widgets/custom_indicator_widget.dart';

final viewModelProvider = ChangeNotifierProvider<ProfilePageViewmodel>(
    (ref) => ProfilePageViewmodel());

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConstMethods _constMethods = ConstMethods();
  //kullanıcı bilgilerini getir
  late Future<Users?> _getUsers;

  //datalar çekildiyse tekrar çekme
  bool _isDataLoaded = false;


  //Kullanıcı bilgilerini gösterecek değişkenler
  String _display_name = "";
  String _profile_photo = "";
  String _cover_photo = "";
  bool _isOnline = false;
  String _username = "";
  //bio yok ise gösterme
  bool _isShowBio = false;
  String _bio = "";
  List<String> _followers = [];



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataLoaded) {
      _getUsers = _getUserInfo();
      _isDataLoaded = true;
    }
  }

  //Kullanıcıları veritabanından çek
  Future<Users?> _getUserInfo() async {
    Users? user = await _constMethods.getUserInfo(context, _auth.currentUser!.uid);
    return user;
  }


  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(viewModelProvider);
    var read = ref.read(viewModelProvider);
    return FutureBuilder(
      future: _getUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Hata: ${snapshot.error}');
          return Center(child: Text('Hata: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text(AppStrings.userNotFound));
        } else {
          //kullanıcı bilgileri değişkenlere işle
          Users user = snapshot.data!;
          _username = user.username;
          _display_name = user.displayName;
          _followers = user.followers!;
          _profile_photo = user.profileImageUrl;
          _cover_photo = user.coverImageUrl;
          _isOnline = user.isOnline;
          _bio = user.bio;
          if(_bio.isNotEmpty){
            _isShowBio = true;
          }

          return _buildBody(watch,read);
        }
      },
    );
  }

  Widget _buildBody(ProfilePageViewmodel watch, ProfilePageViewmodel read) {
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
                child: _cover_photo.isEmpty
                    ? const Center(
                        child: Text(AppStrings.coverPhotoNotFound))
                    : _constMethods.showCachedImage(_cover_photo),
              ),

              // Profil Bilgileri ve Postlar
              Container(
                width: AppSizes.screenWidth(context),
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //online durumu ve ayarlar butonu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //Online Durumu
                         Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: SizedBox(
                            width: 20,
                            child: CircleAvatar(
                              backgroundColor:
                              _isOnline ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                        //Ayarlar butonu
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, "/settings_personel_page",
                                arguments: AppStrings.personalSettings);
                          },
                        ),
                      ],
                    ),

                    // Ad - soyad
                     Center(
                      child: Text(
                        _display_name.isNotEmpty ? _display_name :  AppStrings.userNotFound,

                        style: const TextStyle(fontSize: AppSizes.paddingLarge),
                      ),
                    ),
                    // kullanıcı adı
                     Center(
                      child: Text(
                        _username.isNotEmpty ? _username :  AppStrings.userNotFound,
                        style: const TextStyle(fontSize: AppSizes.paddingMedium),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // bio
                    if (_isShowBio)
                      Center(
                        child: Text(
                          _bio,
                          style: const TextStyle(fontSize: AppSizes.paddingMedium),
                        ),
                      ),

                    const SizedBox(height: 5),

                    // Takipçiler
                     Center(
                      child: Text(
                        "${_followers.length} ${AppStrings.followers}",
                        style: const TextStyle(fontSize: AppSizes.paddingMedium),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const CustomIndicatorWidget(),
                    const SizedBox(height: 10),
                    // Posts
                    _buildPost(),
                  ],
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
              child: _profile_photo.isEmpty
                  ? const Icon(Icons.person, size: 50) // Profil fotoğrafı yoksa ikon göster
                  : ClipOval(
                child: _constMethods.showCachedImage(
                  _profile_photo,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Post görünümleri
  Widget _buildPost() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Eleman $index',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //beğenme butonu
                  IconButton(
                    onPressed: () {
                      // Beğeni butonuna tıklandığında yapılacaklar
                    },
                    icon: const Icon(Icons.heart_broken, color: Colors.white),
                  ),

                  //silme butonu
                  IconButton(
                    onPressed: () {
                      // Silme butonuna tıklandığında yapılacaklar
                    },
                    icon: const Icon(Icons.delete, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      padding: const EdgeInsets.all(5.0),
    );
  }


}
