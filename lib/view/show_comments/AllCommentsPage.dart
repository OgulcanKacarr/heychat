import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/model/Comments.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/view/post/post_page.dart';
import 'package:heychat/view_model/feed/feed_page_view_model.dart';
import 'package:heychat/widgets/custom_app_bar_widget.dart';
import 'package:intl/intl.dart';

final viewModel = ChangeNotifierProvider((ref) => FeedPageViewModel());
class AllCommentsPage extends ConsumerStatefulWidget {
  const AllCommentsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AllCommentsPage> createState() => _AllCommentsPageState();
}

class _AllCommentsPageState extends ConsumerState<AllCommentsPage> {
  String? postId; // late final yerine nullable değişken
  Users? user; // late final yerine nullable değişken

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as List?;
    if (args != null && args.length == 2) {
      postId = args[0] as String;
      user = args[1] as Users;
    }
  }

  @override
  Widget build(BuildContext context) {
    var read = ref.read(viewModel);
    ConstMethods _constMethods = ConstMethods();

    if (postId == null || user == null) {
      return const Scaffold(
        body: Center(child: Text('Post verileri yüklenemedi')),
      );
    }

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: AppStrings.allComments,
        isBack: false,
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/home_page");
        },
      ),
      body: FutureBuilder<List<Comments>>(
        future: read.getComments(postId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Henüz yorum yok.'));
          } else {
            final comments = snapshot.data!;

            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return SingleChildScrollView(
                  child: ListTile(
                    onLongPress: () {
                      read.deleteCommentDialog(context, postId!, comment.text);
                    },
                    title: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: _constMethods.showCachedImage(user!.profileImageUrl),
                        ),
                        const SizedBox(width: 3),
                        Text("${comment.displayName}: ${comment.text}"),
                      ],
                    ),
                    trailing: Text(DateFormat('dd/MM/yyyy').format(comment.createdAt.toDate())),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
