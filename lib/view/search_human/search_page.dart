import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/view_model/search_page_viewmodel.dart';
import 'package:heychat/widgets/custom_textfield_widget.dart';

final view_model = ChangeNotifierProvider((ref) => SearchPageViewmodel());

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  ConstMethods _constMethods = ConstMethods();
  TextEditingController search_person_controller = TextEditingController();
  List<Users> searchResults = [];

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(view_model);
    var read = ref.read(view_model);
    return Scaffold(
      body: _buildBody(watch, read),
    );
  }

  Widget _buildBody(SearchPageViewmodel watch, SearchPageViewmodel read) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 7,
          left: 2,
          right: 2
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  // Textfield genişliğini ayarlamak için Expanded widget kullandık
                  child: CustomTextfieldWidget(
                    hint: AppStrings.search,
                    controller: search_person_controller,
                    keyboardType: TextInputType.text,
                    isPassword: false,
                    prefixIcon: const Icon(Icons.search),
                    isOnChange: true,
                    onchange_func: (value) async {

                      if(value.isNotEmpty){
                        await watch.searchUser(context, value);
                      }else{
                        watch.resetSearch();
                      }
                    },
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: watch.usersList.length,
              itemBuilder: (context, index) {
                Users user = watch.usersList[index];
                return ListTile(
                  leading: _constMethods.showCachedImage(user.profileImageUrl),
                  title: Text(user.displayName),
                  subtitle: Text(user.username),
                  trailing: user.isOnline ? Container(width: 15, child: const CircleAvatar(backgroundColor: Colors.green,)) : Container(width: 15,child: const CircleAvatar(backgroundColor: Colors.grey,)) ,
                  onTap: () {
                    // ListTile'a tıklama işlemini burada işleyebilirsiniz
                    Navigator.pushNamed(context, "/look_page",arguments: user.uid);

                  },

                );
              },
            ),
            if (watch.lastDocument != null) // Eğer daha fazla veri varsa
              ElevatedButton(
                onPressed: () async {
                  await watch.searchUser(context, search_person_controller.text);
                },
                child: const Text('Daha Fazla Yükle'),
              ),






          ],
        ),
      ),
    );
  }
}
