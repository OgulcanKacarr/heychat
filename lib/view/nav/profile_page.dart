import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/widgets/custom_elevated_button_widget.dart';
import 'package:heychat/widgets/custom_indicator_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              // Kapak Fotoğrafı Tasarımı
              CachedNetworkImage(
                imageUrl:
                    "https://avatars.githubusercontent.com/u/63792003?v=4",
                width: AppSizes.screenWidth(context),
                height: AppSizes.screenHeight(context) / 2.5,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: SizedBox(
                            width: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                        //Ayarlar butonu
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, "/settings_personel_page",
                                arguments: AppStrings.personal_settings);
                          },
                        ),
                      ],
                    ),

                    // Ad - soyad
                    const Center(
                      child: Text(
                        "Ogulcan KACAR",
                        style: TextStyle(fontSize: AppSizes.paddingLarge),
                      ),
                    ),
                    // kullanıcı adı
                    const Center(
                      child: Text(
                        "ogulcankacar",
                        style: TextStyle(fontSize: AppSizes.paddingMedium),
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Takipçiler
                    const Center(
                      child: Text(
                        "0 Takipçi",
                        style: TextStyle(fontSize: AppSizes.paddingMedium),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const CustomIndicatorWidget(),

                    //duruma göre etkileşim butonları
                    Visibility(
                      visible: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //takip et butonu
                          CustomElevatedButtonWidget(
                              text: AppStrings.follow, onPressed: () {}),
                          const SizedBox(
                            width: 5,
                          ),

                          //takip silme butonu
                          CustomElevatedButtonWidget(
                              text: AppStrings.delete, onPressed: () {}),
                        ],
                      ),
                    ),
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
            child: const CircleAvatar(
              radius: 50, // Profil fotoğrafının boyutu
              backgroundImage: NetworkImage(
                  "https://github.com/OgulcanKacarr/OgulcanKacarr/raw/main/tr.png"),
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
