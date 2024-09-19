import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/view/chats/chats_page.dart';
import 'package:heychat/view_model/chats/send_message_page_view_model.dart';

final sendMessagePageViewModelProvider = ChangeNotifierProvider((ref) => SendMessagePageViewModel());

class SendMessagePage extends ConsumerStatefulWidget {
  const SendMessagePage({super.key});

  @override
  ConsumerState<SendMessagePage> createState() => _SendMessagePageState();
}

class _SendMessagePageState extends ConsumerState<SendMessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _userId;
  String _messageId = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userId = ModalRoute.of(context)?.settings.arguments as String?;
    if (_userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(sendMessagePageViewModelProvider).fetchUserInfo(context, _userId!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      if (_messageController.text.isNotEmpty) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(sendMessagePageViewModelProvider);
    final ConstMethods _constMethods = ConstMethods();

    return Scaffold(
      appBar: AppBar(
        title: viewModel.user != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/look_page", arguments: _userId);
                },
                child: Text(
                  viewModel.user!.displayName,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            CircleAvatar(
              child: _constMethods.showCachedImage(viewModel.user!.profileImageUrl),
            ),
          ],
        )
            : const Text(AppStrings.loading),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await viewModel.markChatsAsUnread(_messageId);
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.messages.length,
              reverse: true, // Liste ters sırada olsun
              itemBuilder: (context, index) {
                var message = viewModel.messages[index];
                _messageId = message.id;

                //mesaji görüldü yap
                if(!message.isRead) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    viewModel.markMessagesAsRead(message.receiverId,message.id);
                  });
                }


                return Align(
                  alignment: message.senderId == viewModel.currentUserId
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: IntrinsicWidth(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: message.senderId == viewModel.currentUserId ? Colors.green : Colors.purple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.content,
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.visible,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _constMethods.formatDate(message.timestamp),
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          if (message.senderId == viewModel.currentUserId)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  message.isRead ? "Görüldü" : "Gönderildi",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: AppStrings.enter_message,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onTap: _scrollToBottom, // Mesaj yazarken aşağıya kaydır
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      viewModel.sendMessage(_messageController.text.trim(), _userId!);
                      _messageController.clear();
                      _scrollToBottom();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true, // Klavye açılınca ekranın yukarı kaymasını sağlar
    );
  }
}
