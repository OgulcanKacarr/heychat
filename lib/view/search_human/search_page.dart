import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/view_model/search/search_page_viewmodel.dart';
import 'package:heychat/widgets/custom_textfield_widget.dart';

final view_model = ChangeNotifierProvider((ref) => SearchPageViewmodel());

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final ConstMethods _constMethods = ConstMethods();
  final search_person_controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    search_person_controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(view_model);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextfieldWidget(
                hint: AppStrings.search,
                controller: search_person_controller,
                keyboardType: TextInputType.text,
                isPassword: false,
                prefixIcon: const Icon(Icons.search),
                isOnChange: true,
                onchange_func: (value) async {
                  if (value.isNotEmpty) {
                    await watch.searchUser(context, value);
                  } else {
                    watch.resetSearch();
                  }
                },
              ),
              // `Expanded` widget'ını sadece `ListView` içindeki alanı kapsayacak şekilde kullanın
              Expanded(
                child: ListView.builder(
                  itemCount: watch.usersList.length,
                  itemBuilder: (context, index) {
                    Users user = watch.usersList[index];
                    return ListTile(
                      leading: SizedBox(
                        width: 50, // Örnek genişlik
                        height: 50, // Örnek yükseklik
                        child: _constMethods.showCachedImage(user.profileImageUrl),
                      ),
                      title: Text(user.displayName),
                      subtitle: Text(user.username),
                      trailing: user.isOnline
                          ? const SizedBox(width: 15, child: CircleAvatar(backgroundColor: Colors.green,))
                          : const SizedBox(width: 15, child: CircleAvatar(backgroundColor: Colors.grey,)),
                      onTap: () {
                        Navigator.pushNamed(context, "/look_page", arguments: user.uid);
                      },
                    );
                  },
                ),
              ),
              if (watch.hasMore) // Check if there is more data to load
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await watch.searchUser(context, search_person_controller.text);
                    },
                    child: const Text('Daha Fazla Yükle'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
