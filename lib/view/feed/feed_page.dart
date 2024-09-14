import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/model/PostWithUser.dart';
import 'package:heychat/view_model/feed/feed_page_view_model.dart';
import 'package:heychat/widgets/CommentButton.dart';
import 'package:heychat/widgets/LikeButton.dart';

final viewModelProvider = ChangeNotifierProvider((ref) => FeedPageViewModel());

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  late Future<List<PostWithUser>> _feedPostsFuture;

  @override
  void initState() {
    super.initState();
    _feedPostsFuture = ref.read(viewModelProvider).getFeedPostsWithUserInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final _constMethods = ConstMethods();

    return Scaffold(
      body: FutureBuilder<List<PostWithUser>>(
        future: _feedPostsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text(AppStrings.userNotFound));
          } else {
            List<PostWithUser> userPosts = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: userPosts.map((post) {
                  return _buildBody(post, _auth.currentUser!.uid, _constMethods);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildBody(PostWithUser user, String currentUserId, _constMethods) {
    var watch = ref.watch(viewModelProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil fotoğrafı ve isim
            profilePhotoAndDisplayName(user, _constMethods),
            const Divider(),
            // Post görseli
            postImage(user, _constMethods),
            const SizedBox(height: 10),
            // Butonlar
            postButtons(user, _constMethods, currentUserId),
            // Kullanıcı adı ve post açıklaması
            usernameAndDescription(user, _constMethods),
            // Yorum yapma butonu aç veya kapat
            Visibility(
              visible: !watch.open_comment_status,
              child: CommentButton(post: user.post, users: user.user, currentUserId: currentUserId),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget profilePhotoAndDisplayName(PostWithUser user, ConstMethods _constMethods) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          child: _constMethods.showCachedImage(user.user.profileImageUrl),
        ),
        const SizedBox(width: 1),
        TextButton(
          child: Text(user.user.displayName),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/look_page", arguments: user.user.uid);
          },
        ),
      ],
    );
  }

  Widget postImage(PostWithUser user, ConstMethods _constMethods) {
    return GestureDetector(
      onDoubleTap: () async {
        // Double tap action
      },
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: _constMethods.showCachedImage(user.post.imageUrl),
      ),
    );
  }

  Widget postButtons(PostWithUser user, ConstMethods _constMethods, String currentUserId) {
    return Row(
      children: [
        LikeButton(post: user.post, currentUserId: currentUserId),
        IconButton(
          onPressed: () {
            ref.read(viewModelProvider.notifier).enterComment();
          },
          icon: const Icon(Icons.comment),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        const Spacer(),
        Text(_constMethods.formatDate(user.post.createdAt.toDate())),
      ],
    );
  }

  Widget usernameAndDescription(PostWithUser user, ConstMethods _constMethods) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Row(
        children: [
          Text("${user.user.username}: ${user.post.caption}"),
        ],
      ),
    );
  }
}
