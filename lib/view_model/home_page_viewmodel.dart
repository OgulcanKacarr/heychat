import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/view/chats/chats_page.dart';
import 'package:heychat/view/nav/flow_page.dart';
import 'package:heychat/view/profile/profile_page.dart';
import 'package:heychat/view/search_human/search_page.dart';

class HomePageViewmodel extends ChangeNotifier {
  //sayfanın başlıklarını title'da göstermek için
  List<String> labels = [
    AppStrings.chats,
    AppStrings.flow,
    AppStrings.search,
    AppStrings.profile,
  ];
  String _title = AppStrings.chats;
  //sayfanın güncel durumu
  int bottom_nav_current_index = 0;
  //chat sayfasında değişiklik olursa bildirime göster
  int _chats_notificationCount = 0;

  String get title => _title;
  int get notificationCount => _chats_notificationCount;

  //appbar bazı sayfalarda göstermemek için
  bool _showAppBar = true;
  bool get showAppBar => _showAppBar;



  // Bottom Nav bar items
  List<BottomNavigationBarItem> get items {
    return [
      BottomNavigationBarItem(
        icon: Stack(
          children: [
            const Icon(Icons.chat),
            if (_chats_notificationCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      '$_chats_notificationCount',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        label: AppStrings.chats,
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.arrow_downward_rounded), label: AppStrings.flow),
      const BottomNavigationBarItem(icon: Icon(Icons.search), label: AppStrings.search),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: AppStrings.profile),
    ];
  }

  // Sayfa değişikliği
  void setCurrentIndex(int i) {
    bottom_nav_current_index = i;
    _title = labels[i];
    _showAppBar = i != 3;
    notifyListeners();
  }

  // Sohbet değiştiğinde bildirim ver
  void updateNotificationCount(int count) {
    _chats_notificationCount = count;
    notifyListeners();
  }


  // Sayfalar
  Widget buildBody() {
    switch (bottom_nav_current_index) {
      case 0:
        return ChatsPage();
      case 1:
        return FlowPage();
      case 2:
        return SearchPage();
      case 3:
        return ProfilePage();
      default:
        return ChatsPage();
    }
  }
}
