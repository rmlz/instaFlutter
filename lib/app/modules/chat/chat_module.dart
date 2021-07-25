import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamon/app/constants.dart';
import 'package:instamon/app/modules/chat/chatList_page.dart';
import 'package:instamon/app/modules/chat/chat_page.dart';
import 'package:instamon/app/modules/chat/chat_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ChatStore(
        firebaseFirestore: i.get<FirebaseFirestore>(),
        firebaseAuth: i.get<FirebaseAuth>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ChatListPage()),
    ChildRoute('${Constants.Routes.CHAT_SCREEN}/:id',
        child: (_, args) => ChatPage(key: UniqueKey(), id: args.params['id']),
        transition: TransitionType.rightToLeft)
  ];
}
