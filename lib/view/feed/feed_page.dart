import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/model/PostWithUser.dart';
import 'package:heychat/view_model/feed/feed_page_view_model.dart';

final viewModel = ChangeNotifierProvider((ref) => FeedPageViewModel());

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final ConstMethods _constMethods = ConstMethods();
  late Future<List<PostWithUser>> _postsWithUsers;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _postsWithUsers = _getPost();
  }

  Future<List<PostWithUser>> _getPost() async {
    return await ref.read(viewModel).getFeedPostsWithUserInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(viewModel);
    var read = ref.read(viewModel);
    return Scaffold(
      body: FutureBuilder<List<PostWithUser>>(
        future: _postsWithUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text(AppStrings.userNotFound));
          } else {
            List<PostWithUser> userPosts = snapshot.data!;

            return ListView.builder(
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                final post = userPosts[index];
                return _buildBody(read, watch, post);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildBody(FeedPageViewModel read, FeedPageViewModel watch, PostWithUser user) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                //profil fotoğrafı
                CircleAvatar(
                  radius: 25,
                  child: _constMethods.showCachedImage(user.user.profileImageUrl),
                ),
                const SizedBox(width: 1),
                //display name
                TextButton(
                  child: Text(user.user.displayName),
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, "/look_page",arguments: user.user.uid);
                  },
                ),
              ],
            ),
             Container(width: AppSizes.screenWidth(context),color: Colors.black, height: 2.0,),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 4 / 3, // Genişlik/yükseklik oranı
              child: _constMethods.showCachedImage(user.post.imageUrl),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                const Spacer(),
                Text(_constMethods.formatDate(user.post.createdAt.toDate())),// Tarih sağ tarafa hizalandı
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text("${user.user.username}: ${user.post.caption}"),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
