import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/view/chats/chats_page.dart';
import 'package:heychat/view/feed/feed_page.dart';
import 'package:heychat/view/profile/profile_page.dart';
import 'package:heychat/view/search_human/search_page.dart';
import 'package:heychat/view_model/chats/chats_page_view_model.dart';


final homePageViewModelProvider = ChangeNotifierProvider<HomePageViewmodel>((ref) => HomePageViewmodel());
class HomePageViewmodel extends ChangeNotifier {
  final ConstMethods _constMethods = ConstMethods();

  List<String> labels = [
    AppStrings.chats,
    AppStrings.feed,
    AppStrings.search,
    AppStrings.profile,
  ];

  String _title = AppStrings.chats;
  int bottom_nav_current_index = 0;

  bool _showAppBar = true;

  String get title => _title;
  bool get showAppBar => _showAppBar;



  List<BottomNavigationBarItem> get items {
    return [
      BottomNavigationBarItem(
        icon: Stack(
          children: [
            const Icon(Icons.chat),
          ],
        ),
        label: AppStrings.chats,
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.arrow_downward_rounded), label: AppStrings.feed),
      const BottomNavigationBarItem(icon: Icon(Icons.search), label: AppStrings.search),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: AppStrings.profile),
    ];
  }



  void setCurrentIndex(int i) {
    bottom_nav_current_index = i;
    _title = labels[i];
    _showAppBar = i != 3;
    notifyListeners();
  }

  Widget buildBody() {
    switch (bottom_nav_current_index) {
      case 0:
        return const ChatsPage(); // ChatsPage'e parametre geçmiyoruz
      case 1:
        return const FeedPage();
      case 2:
        return const SearchPage();
      case 3:
        return const ProfilePage();
      default:
        return const ChatsPage();
    }
  }
}
