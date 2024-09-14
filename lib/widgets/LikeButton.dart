import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/model/Posts.dart';
import 'package:heychat/view/feed/feed_page.dart';
import 'package:heychat/view_model/feed/feed_page_view_model.dart';

final viewModel = ChangeNotifierProvider((ref) => FeedPageViewModel());
class LikeButton extends ConsumerStatefulWidget {
  final Posts post;
  final String currentUserId;

  LikeButton({
    required this.post,
    required this.currentUserId,
  });

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends ConsumerState<LikeButton> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLikedByUser(widget.currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    var read = ref.read(viewModel);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () async {
            setState(() {
              if (isLiked) {
                widget.post.removeLike(widget.currentUserId);
              } else {
                widget.post.addLike(widget.currentUserId);
              }
              isLiked = !isLiked;
            });

            try {
              await read.likePost(widget.post.postId, widget.post.likes);
            } catch (e) {
              print('Post beğeni güncelleme hatası: $e');
            }
          },
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : null,
          ),

        ),
        Text("${widget.post.likes.length}"),
      ],
    );
  }
}
