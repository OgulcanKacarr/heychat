import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:heychat/model/Posts.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:heychat/view_model/profil/look_page_viewmodel.dart';
import 'package:heychat/widgets/LikeButton.dart';
import 'package:heychat/widgets/custom_indicator_widget.dart';

final viewModelProvider = ChangeNotifierProvider((ref) => LookPageViewmodel());

class LookProfile extends ConsumerStatefulWidget {
  LookProfile({super.key});

  @override
  ConsumerState<LookProfile> createState() => _LookProfileState();
}

class _LookProfileState extends ConsumerState<LookProfile> {
  final FirebaseFirestoreService _firestoreService = FirebaseFirestoreService();
  String? _userId;
  late Future<Users?> _futureUser;
  bool _isOnline = false;
  String? _currentUserId;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userId = ModalRoute.of(context)?.settings.arguments as String?;
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _futureUser = _getUserInfo();


    if (_userId != null && _currentUserId != null) {
      // Takip durumunu kontrol et
      ref.read(viewModelProvider).getTargetPosts(_userId!);
      ref.read(viewModelProvider).checkFollowReceive(_currentUserId!, _userId!);
      ref.read(viewModelProvider).checkFollowSend(_currentUserId!, _userId!);
      ref.read(viewModelProvider).checkFriends(_currentUserId!, _userId!);
      ref.read(viewModelProvider).getFollowers(context, _userId!);
    }

  }

  Future<Users?> _getUserInfo() async {
    if (_userId != null && _userId!.isNotEmpty) {
      Users? user = await _firestoreService.getUsersInfoFromDatabase(context, _userId!);
      if (user != null) {
        return user;
      } else {
        ShowSnackBar.show(context, AppStrings.errorFetchingUser);
        return null;
      }
    } else {
      ShowSnackBar.show(context, AppStrings.errorFetchingUser);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final watch = ref.watch(viewModelProvider);
    final read = ref.read(viewModelProvider);

    return Scaffold(
      body: FutureBuilder<Users?>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Hata: ${snapshot.error}');
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text(AppStrings.userNotFound));
          } else {
            Users user = snapshot.data!;
            return _buildBody(read, watch, user);
          }
        },
      ),
    );
  }
  Widget _buildBody(LookPageViewmodel read, LookPageViewmodel watch, Users user) {
    final ConstMethods _constMethods = ConstMethods();
    return SingleChildScrollView(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              //Kapak Fotoğrafı
              SizedBox(
                width: AppSizes.screenWidth(context),
                height: AppSizes.screenHeight(context) / 2.5,
                child: user.coverImageUrl.isEmpty
                    ? const Center(child: Text(AppStrings.coverPhotoNotFound))
                    : Image.network(user.coverImageUrl, fit: BoxFit.cover),
              ),
              //Durum ve Geri Nesneleri
              Container(
                width: AppSizes.screenWidth(context),
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "/home_page");
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: SizedBox(
                            width: 20,
                            child: CircleAvatar(
                              backgroundColor: _isOnline ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //İsim
                    Center(
                      child: Text(
                        user.displayName.isNotEmpty ? user.displayName : AppStrings.userNotFound,
                        style: const TextStyle(fontSize: AppSizes.paddingLarge),
                      ),
                    ),
                    //Kullanıcı adı
                    Center(
                      child: Text(
                        user.username.isNotEmpty ? user.username : AppStrings.userNotFound,
                        style: const TextStyle(fontSize: AppSizes.paddingMedium),
                      ),
                    ),
                    const SizedBox(height: 15),
                    //bio
                    if (user.bio.isNotEmpty)
                      Center(
                        child: Text(
                          user.bio,
                          style: const TextStyle(fontSize: AppSizes.paddingMedium),
                        ),
                      ),
                    const SizedBox(height: 5),
                    //takipçi
                    Center(
                      child: TextButton(
                        child: Text(
                          "${user.followers != null ? user.followers!.length : 0} ${AppStrings.followers}",
                          style: const TextStyle(fontSize: AppSizes.paddingMedium),
                        ),
                        onPressed: () async {
                          // Takipçileri çek ve modalı göster
                          List<Users> followers = (await watch.getFollowers(context, _userId!)) as List<Users>;
                          if (followers.isNotEmpty) {
                            _constMethods.showFollowersModal(context, user.uid!);
                          } else {
                          }
                        },
                      ),

                    ),
                    const SizedBox(height: 10),
                    const CustomIndicatorWidget(),
                    const SizedBox(height: 10),

                    //takipçi butonu
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              if (_currentUserId == _userId) return; // Kendi profilinizde işlem yapmayı engelleyin

                              if (watch.isFollowing) {
                                // Zaten takip ediliyorsa, takibi bırak
                                await read.unFollow(_currentUserId!, _userId!);
                              } else if (watch.isRequestSent) {
                                // İstek gönderildiyse, iptal et
                                await read.cancelFollowRequest(_currentUserId!, _userId!);
                              } else if (watch.isRequestReceived) {
                                // İstek alındıysa, kabul et
                                await read.acceptFollowRequest(_currentUserId!, _userId!);
                              } else if (watch.isUnFollow) {
                                // Takip bırakıldıysa, güncelle
                                await read.unFollow(_currentUserId!, _userId!);
                              } else {
                                // İstek gönderilmediyse, takip isteği gönder
                                await read.sendFollow(_currentUserId!, _userId!);
                              }
                            },
                            child: Text(
                              watch.isUnFollow
                                  ? 'Takip et'
                                  : watch.isRequestSent
                                  ? 'İstek Gönderildi'
                                  : watch.isRequestReceived
                                  ? 'Kabul Et' // İstek alındığında bu metni göster
                                  : watch.isFollowing
                                  ? 'Takipten çık'
                                  : 'Takip Et',
                            ),
                          ),
                        ],
                      ),
                    ),

                    _buildPost(watch,read,_constMethods),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: AppSizes.screenHeight(context) / 2.5 - 50,
            left: (AppSizes.screenWidth(context) / 2) - 50,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              child: user.profileImageUrl.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : ClipOval(
                child: Image.network(
                  user.profileImageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(LookPageViewmodel watch, LookPageViewmodel read, ConstMethods _constMethods) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: watch.getPost.length,
      itemBuilder: (context, index) {
        Posts post = watch.getPost[index];
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
                           LikeButton(post: post, currentUserId: _userId!),
                        ],
                      ),
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
