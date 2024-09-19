import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/model/Posts.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/view_model/profil/profile_page_viewmodel.dart';
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
    ref.read(viewModelProvider).getMyPosts();
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


          return _buildBody(watch,read, user);
        }
      },
    );
  }

  Widget _buildBody(ProfilePageViewmodel watch, ProfilePageViewmodel read, Users user) {
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
                          padding: const EdgeInsets.only(left: 10),
                          child: SizedBox(
                            width: 20,
                            child: CircleAvatar(
                              backgroundColor:
                              user.isOnline ? Colors.green : Colors.grey,
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
                        user.displayName.isNotEmpty ? user.displayName :  AppStrings.userNotFound,

                        style: const TextStyle(fontSize: AppSizes.paddingLarge),
                      ),
                    ),
                    // kullanıcı adı
                     Center(
                      child: Text(
                        user.username.isNotEmpty ? user.username :  AppStrings.userNotFound,
                        style: const TextStyle(fontSize: AppSizes.paddingMedium),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // bio
                    if (user.bio.isNotEmpty)
                      Center(
                        child: Text(
                          user.bio,
                          style: const TextStyle(fontSize: AppSizes.paddingMedium),
                        ),
                      ),

                    const SizedBox(height: 5),

                    // Takipçiler
                     Center(
                      child: TextButton(
                        child: Text(
                          "${user.followers!.length} ${AppStrings.followers}",
                          style: const TextStyle(fontSize: AppSizes.paddingMedium),
                        ),
                        onPressed: () async {
                          await _constMethods.showFollowersModal(context, user.uid!);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const CustomIndicatorWidget(),
                    const SizedBox(height: 10),
                    // Posts
                    _buildPost(watch,read),
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
          ),
        ],
      ),
    );
  }

  //Post görünümleri
  Widget _buildPost(ProfilePageViewmodel watch, ProfilePageViewmodel read) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: watch.getMyPost.length,
      itemBuilder: (context, index) {
        Posts post = watch.getMyPost[index];
        return Card(
          elevation: 5, // Gölge efekti
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    _constMethods.showCachedImage(
                      post.imageUrl,
                      width: double.infinity,

                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Beğenme butonu
                    GestureDetector(
                      onTap: () {
                        // Beğeni butonuna tıklandığında yapılacaklar
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.favorite_border, color: Colors.red),
                          const SizedBox(width: 5),
                          Text(post.likes.length.toString()),
                        ],
                      ),
                    ),
                    // Silme butonu
                    IconButton(
                      onPressed: () async {
                        // Silme butonuna tıklandığında yapılacaklar
                        await watch.deletePost(post.postId, post.imageUrl);
                      },
                      icon: const Icon(Icons.delete, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      padding: const EdgeInsets.all(5.0),
    );
  }


}
