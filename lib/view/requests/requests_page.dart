import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/view_model/request/requests_page_view_model.dart';
import 'package:heychat/widgets/custom_app_bar_widget.dart';
import 'package:heychat/model/Users.dart';

final viewModel = ChangeNotifierProvider((ref) => RequestsPageViewModel());

class RequestsPage extends ConsumerStatefulWidget {
  const RequestsPage({super.key});

  @override
  ConsumerState<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends ConsumerState<RequestsPage> {
  final ConstMethods _constMethods = ConstMethods();

  @override
  void initState() {
    super.initState();
    ref.read(viewModel).getRequests();
  }

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(viewModel);
    var read = ref.read(viewModel);

    return Scaffold(
        appBar: CustomAppBarWidget(
            title: AppStrings.requests,
          isBack: false,
          onPressed: (){
            Navigator.pushReplacementNamed(context, "/home_page");
          },
        ),
        body: watch.requests.isEmpty
            ? const Center(
                child: Text(AppStrings.noRequests),
              )
            : ListView.builder(
                itemCount: watch.requests.length,
                itemBuilder: (context, index) {
                  final request = watch.requests[index];
                  final user = request['user'] as Users;
                  return ListTile(
                    leading: SizedBox(
                      width: 50,  // Örnek genişlik
                      height: 50, // Örnek yükseklik
                      child: _constMethods.showCachedImage(user.profileImageUrl),
                    ),
                    title: Text(user.displayName),
                    subtitle: Text(user.username),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/look_page",
                          arguments: user.uid);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await watch
                                .acceptRequest(user.uid.toString());
                          },
                          icon: const Icon(Icons.circle_rounded,
                              color: Colors.green),
                        ),
                        IconButton(
                          onPressed: () async {
                            await watch
                                .cancelRequest(user.uid.toString());
                          },
                          icon: const Icon(Icons.circle_rounded,
                              color: Colors.redAccent),
                        ),
                      ],
                    ),
                  );
                }));
  }
}
