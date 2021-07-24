import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/constants.dart';
import 'package:instaflutter/app/modules/chat/chat_store.dart';
import 'package:instaflutter/app/shared/util/LoadingWidget.dart';

class ChatListPage extends StatefulWidget {
  final String title;
  const ChatListPage({Key? key, this.title = 'Chat'}) : super(key: key);
  @override
  ChatListPageState createState() => ChatListPageState();
}

class ChatListPageState extends ModularState<ChatListPage, ChatStore> {
  @override
  void initState() {
    store.loadUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.pushNamed(context, Constants.Routes.FEED);
        }),
        title: Text(widget.title),
      ),
      body: Container(child: Observer(
        builder: (_) {
          return StreamBuilder(
              stream: store.userList,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Deu pau!');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingWidget();
                }
                if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                  final chats = snapshot.data!.docs;
                  return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        final chatMap = chat.data() as Map<String, dynamic>;
                        final containPic =
                            chatMap.containsKey('profilePicture') ||
                                chatMap['profilePicture'] != null;
                        return InkWell(
                            onTap: () {
                              final chatMap =
                                  chat.data() as Map<String, dynamic>;
                              Modular.to.pushNamed(
                                  '.${Constants.Routes.CHAT_SCREEN}/${chatMap['id']}');
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(children: [
                                  CircleAvatar(
                                      radius: 35,
                                      backgroundImage: containPic
                                          ? NetworkImage(chat['profilePicture'])
                                          : AssetImage('assets/user.png')
                                              as ImageProvider),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(chat['displayName'] as String,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text('Clique para conversar')
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('10:00'),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Icon(
                                        Icons.circle,
                                        color: Theme.of(context).accentColor,
                                        size: 16,
                                      )
                                    ],
                                  )
                                ])));
                      });
                }
                return LoadingWidget();
              });
        },
      )),
    );
  }
}
