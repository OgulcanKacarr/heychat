import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/model/Comments.dart';
import 'package:heychat/model/Posts.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/view/feed/feed_page.dart';
import 'package:heychat/view_model/feed/feed_page_view_model.dart';
import 'package:intl/intl.dart';

final viewModel = ChangeNotifierProvider((ref) => FeedPageViewModel());

class CommentButton extends ConsumerStatefulWidget {
  final Posts post;
  final Users users;
  final String currentUserId;

  CommentButton({
    required this.post,
    required this.users,
    required this.currentUserId,
  });

  @override
  _CommentButtonState createState() => _CommentButtonState();
}

class _CommentButtonState extends ConsumerState<CommentButton> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var read = ref.read(viewModel);

    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Column(
        children: [
          // Yorumları getir

          Container(
            constraints: const BoxConstraints(
              maxHeight: 70, // Maksimum yükseklik
            ),
            child: FutureBuilder<List<Comments>>(
              future: read.getComments(widget.post.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Henüz yorum yok.'));
                } else {
                  final comments = snapshot.data!;

                  return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final comment = comments[index];
                            return ListTile(
                              title: Text("${widget.users.username}: ${comment.text}"),
                              trailing: Text(DateFormat('dd/MM/yyyy').format(comment.createdAt.toDate())),
                              subtitle: Center(
                                child: TextButton(
                                  onPressed: (){

                                  },
                                  child: const Text("Tüm yorumları gör",style: TextStyle(fontSize: 10),),
                                ),
                              ),
                            );
                          },
                          childCount: comments.length,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 8.0), // Buton ile yorumlar arasına boşluk ekle
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: AppStrings.enter_comment,
                      prefixIcon: Icon(Icons.comment)),
                  controller: _controller,
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(width: 8.0), // Buton ile TextField arasına boşluk ekle
              ElevatedButton(
                onPressed: () async {
                  await read.sendComment(widget.post.postId, _controller.text);
                  _controller.clear();
                },
                child: const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
