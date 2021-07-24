import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/constants.dart';
import 'package:instaflutter/app/modules/chat/chat_store.dart';
import 'package:instaflutter/app/shared/util/LoadingWidget.dart';

class ChatPage extends StatefulWidget {
  final id;

  const ChatPage({Key? key, required this.id}) : super(key: key);
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends ModularState<ChatPage, ChatStore> {
  late TextEditingController _messageController;
  late Future<String> chattingWith;
  late Map chattingObj;
  late String chattingWithName;
  late String chattingWithProfilePic;
  final focusNode = FocusNode();
  var isTyping = false;

  @override
  void initState() {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        store.sendIsTexting(false);
        store.amItexting = true;
      }
    });
    store.loadUser();
    store.chattingUserId = widget.id;
    chattingWithName = '';
    chattingWithProfilePic = '';
    store.createOrLoadChat();
    _messageController = TextEditingController();
    _messageController.addListener(() {
      if (!store.amItexting) {
        store.sendIsTexting(true);
      }
      store.amItexting =
          focusNode.hasFocus && _messageController.text.length > 0;
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, Constants.Routes.CHAT);
          },
        ),
        title: FutureBuilder(
          future: store.loadUserObj(),
          builder: (context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return LoadingWidget();
              default:
                if (snapshot.hasError) {
                  return Text('DEU PAU');
                }
                return Text(snapshot.data['displayName']);
            }
          },
        ),
      ),
      body: Observer(
        builder: (context) {
          return StreamBuilder(
              stream: store.chatList,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container(
                      color: Colors.white, child: Text('Deu pau!'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingWidget();
                }

                if (snapshot.hasData) {
                  final chatObj = snapshot.data!.data() as Map<String, dynamic>;
                  store.showOtherUserTiping(chatObj);
                  return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Flex(direction: Axis.vertical, children: [
                        Expanded(
                          child: Container(
                              color: Colors.white,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25.0),
                                    topLeft: Radius.circular(25.0)),
                                child: FutureBuilder(
                                    future: store.loadUserObj(),
                                    builder: (context,
                                        AsyncSnapshot snapshotFuture) {
                                      if (snapshotFuture.connectionState ==
                                          ConnectionState.waiting) {
                                        return LoadingWidget();
                                      }
                                      if (snapshotFuture.hasError) {
                                        return Text('DEU PAU');
                                      }
                                      return ListView.builder(
                                          reverse: true,
                                          padding: EdgeInsets.only(top: 20),
                                          itemCount: chatObj['messages'].length,
                                          itemBuilder: (ctx, index) {
                                            final messageIdx =
                                                chatObj['messages'][index];
                                            final name;
                                            final avatarPic;
                                            if (messageIdx['from'] ==
                                                store.user!.id) {
                                              name = store.user!
                                                  .data()!['displayName'];
                                              avatarPic = store.user!
                                                  .data()!['profilePicture'];
                                            } else {
                                              name = snapshotFuture
                                                  .data['displayName'];
                                              avatarPic = snapshotFuture
                                                  .data['profilePicture'];
                                            }
                                            return ChatMessage(
                                                date: chatObj['messages'][index]
                                                    ['date'],
                                                avatarPic: avatarPic,
                                                name: name,
                                                message: chatObj['messages']
                                                    [index]['message'],
                                                isMe: messageIdx['from'] ==
                                                    store.user!.id);
                                          });
                                    }),
                              )),
                        ),
                        TextEditor(
                          textController: _messageController,
                          store: store,
                          focus: focusNode,
                          isTyping: store.isOtherTexting,
                        )
                      ]));
                }
                return Container(
                  color: Colors.white,
                  child: Text('LOADING'),
                );
              });
        },
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  late final String avatarPic;
  late final String name;
  late final String message;
  late final bool isMe;
  late final String date;

  late final EdgeInsets ballonMargin;
  late final Color ballonColor;
  late final CrossAxisAlignment txtGravity;
  late final EdgeInsets ballonPad;

  ChatMessage(
      {required this.avatarPic,
      required this.name,
      required this.message,
      required this.isMe,
      required this.date});

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      ballonColor = Color(0xFFA3cca6);
      ballonMargin = EdgeInsets.only(top: 6, bottom: 8, left: 60);
      txtGravity = CrossAxisAlignment.end;
      ballonPad = EdgeInsets.only(left: 4, right: 8, top: 12, bottom: 12);
    } else {
      ballonColor = Color(0xFF8af18e);
      ballonMargin = EdgeInsets.only(top: 6, bottom: 8, right: 60);
      txtGravity = CrossAxisAlignment.start;
      ballonPad = EdgeInsets.only(left: 8, right: 4, top: 12, bottom: 12);
    }
    return Flexible(
      child: Container(
        margin: ballonMargin,
        padding: ballonPad,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: ballonColor),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarPic),
                )
              ],
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: txtGravity,
                children: [
                  Text(
                    date,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF356778),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(message,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextEditor extends StatelessWidget {
  final TextEditingController textController;
  final ChatStore store;
  final FocusNode focus;
  final bool isTyping;

  TextEditor(
      {required this.textController,
      required this.store,
      required this.focus,
      required this.isTyping});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Theme.of(context).secondaryHeaderColor,
      child: Column(
        children: [
          Row(
            children: [
              Text(isTyping
                  ? 'Seu coleguinha de conversa está digitando...'
                  : ''),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: focus,
                  textAlign: TextAlign.left,
                  controller: textController,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  decoration: InputDecoration(hintText: 'Digite sua mensagem'),
                ),
              ),
              IconButton(
                  onPressed: () {
                    store.sendMessage(textController.text);
                    textController.text = '';
                  },
                  icon: Icon(Icons.send_rounded))
            ],
          ),
        ],
      ),
    );
  }
}
