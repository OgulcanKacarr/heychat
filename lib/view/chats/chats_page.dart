import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/model/Chats.dart';
import 'package:heychat/services/firebase_firestore_service.dart';
import 'package:heychat/view_model/chats/chats_page_view_model.dart';
import 'package:heychat/widgets/custom_floatingactionbutton_widget.dart';
import 'package:intl/intl.dart';

final viewModel = ChangeNotifierProvider((ref) => ChatsPageViewModel());

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({super.key});

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  @override
  void initState() {
    super.initState();
    // İlk veriyi yükle
    Future.delayed(Duration.zero, () {
      ref.read(viewModel).refreshChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ConstMethods _constMethods = ConstMethods();
    var watch = ref.watch(viewModel);
    var read = ref.read(viewModel);

    return RefreshIndicator(
      onRefresh: () async {
        // Verileri yenile
        await ref.read(viewModel).refreshChats();
      },
      child: Scaffold(
        body: _buildBody(watch,read, _constMethods),
        floatingActionButton: CustomFloatingactionbuttonWidget(),
      ),
    );
  }

  Widget _buildBody(ChatsPageViewModel watch, ChatsPageViewModel read, ConstMethods _constMethods){
   return  Column(
     children: [
       if(watch.unreadMessageCount > 0)
         Row(
           children: [
              Text("Toplam: ${watch.unreadMessageCount} sohbet"),
           ],
         ),

       Expanded(
         child: StreamBuilder<List<Chats>>(
           stream: watch.chatsStream,
           builder: (context, snapshot) {
             if (!snapshot.hasData) {
               return const Center(child: CircularProgressIndicator());
             }
             if (snapshot.data!.isEmpty) {
               return const Center(child: Text(AppStrings.empty_chat));
             }
             var chats = snapshot.data!;
             return ListView.builder(
               itemCount: chats.length,
               itemBuilder: (context, index) {
                 var user = chats[index];
                 String date = DateFormat('dd.MM.yyyy HH:mm').format(user.lastMessageTimestamp);

                 return ListTile(

                   onLongPress: () async {
                     await watch.deleteChat(chatId: user.chatId);
                   },
                   leading: CircleAvatar(
                     child: _constMethods.showCachedImage(user.user.profileImageUrl),
                   ),
                   title: Text(user.user.displayName),
                   subtitle: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         user.lastMessage,
                         style: TextStyle(
                           fontStyle: FontStyle.italic,
                           fontWeight: user.isRead ? FontWeight.normal : FontWeight.bold,
                         ),
                       ),
                       Text(
                         "${AppStrings.last_chat} ${date}",
                         style: const TextStyle(fontSize: 10),
                       ),
                     ],
                   ),
                   onTap: () async {
                     await watch.markMessagesAsRead(user.chatId);
                     Navigator.pushNamed(context, "/send_message_page", arguments: user.user.uid);
                   },
                   trailing: CircleAvatar(
                     radius: 7,
                     backgroundColor: user.user.isOnline ? Colors.green : Colors.grey,
                   ),
                 );
               },
             );
           },
         ),
       )
     ],
   );
  }
}
