import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

import '../../constants.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatStoreBase with _$ChatStore;

abstract class _ChatStoreBase with Store {
  FirebaseFirestore firebaseFirestore;
  FirebaseAuth firebaseAuth;

  _ChatStoreBase({required this.firebaseAuth, required this.firebaseFirestore});

  DocumentSnapshot<Map<String, dynamic>>? user;

  String? chattingUserId;

  @observable
  String? chatId;

  @observable
  Stream<QuerySnapshot>? userList = Stream.empty();

  @observable
  Stream<DocumentSnapshot> chatList = Stream.empty();

  @observable
  bool isOtherTexting = false;

  bool amItexting = false;

  String? userOne;

  String? userTwo;

  DocumentSnapshot<Map<String, dynamic>>? lastChat;

  @action
  Future<void> loadUser() async {
    user = await firebaseFirestore
        .doc('${Constants.Collections.USERS}/${firebaseAuth.currentUser!.uid}')
        .get();
  }

  @action
  Future<void> loadUserList() async {
    await loadUser();

    final following = user!.data()!['following'];

    userList = await firebaseFirestore
        .collection(Constants.Collections.USERS)
        .where('id', whereIn: following)
        .snapshots();
  }

  Future<DocumentSnapshot> loadUserObj() {
    return firebaseFirestore
        .collection(Constants.Collections.USERS)
        .doc(chattingUserId)
        .get();
  }

  @action
  Future<void> createOrLoadChat() async {
    final coll = firebaseFirestore.collection(Constants.Collections.CHATS);

    final queryRef1 = await coll
        .where('participants.userOne.id', isEqualTo: user!['id'])
        .where('participants.userTwo.id', isEqualTo: chattingUserId!)
        .get();

    final queryRef2 = await coll
        .where('participants.userTwo.id', isEqualTo: user!['id'])
        .where('participants.userOne.id', isEqualTo: chattingUserId!)
        .get();

    if (queryRef1.docs.isEmpty && queryRef2.docs.isEmpty) {
      await coll.add({
        'participants': {
          'userOne': {'id': user!.id, 'isTyping': false},
          'userTwo': {'id': chattingUserId, 'isTyping': false},
        },
        'lastMessageDateTime': DateTime.now().toIso8601String(),
        'messages': [],
        'lastMessage': {'from': '', 'to': '', 'isRead': false},
        'isSomeoneTexting': false
      }).then((docRef) => {
            chatId = docRef.id,
            docRef.set({'id': docRef.id}, SetOptions(merge: true)),
            userOne = user!['id'],
            userTwo = chattingUserId
          });
    } else if (queryRef1.docs.isNotEmpty) {
      chatId = queryRef1.docs.first.id;
      userOne = user!['id'];
      userTwo = chattingUserId;
    } else {
      chatId = queryRef2.docs.first.id;
      userOne = chattingUserId;
      userTwo = user!['id'];
    }
    chatList = coll.doc(chatId).snapshots();
    lastChat = await coll.doc(chatId).get();
  }

  void setUserOneAndTwo(String uOne, String uTwo) {
    userOne = uOne;
    userTwo = uTwo;
  }

  Future<void> sendIsTexting(bool isTexting) async {
    final coll = firebaseFirestore.collection(Constants.Collections.CHATS);
    var participants = lastChat!.data()!['participants'];
    var userOne = participants['userOne'] as Map<String, dynamic>;
    if (user!.id == userOne['id']) {
      participants['userOne']['isTyping'] = isTexting;
    } else {
      participants['userTwo']['isTyping'] = isTexting;
    }
    await coll
        .doc(chatId)
        .set({'participants': participants}, SetOptions(merge: true));
  }

  Future<void> sendMessage(String message) async {
    message.replaceAll(RegExp(r"/\s\s+/g"), ' ');
    if (message.length > 0) {
      final now = DateTime.now().toIso8601String();
      final messageObj = {
        'from': firebaseAuth.currentUser!.uid,
        'message': message,
        'date': now
      };
      final lastMessage = {
        'from': firebaseAuth.currentUser!.uid,
        'to': chattingUserId,
        'isRead': false
      };
      var fullObj;
      var messageList = [];
      final coll = firebaseFirestore.collection(Constants.Collections.CHATS);
      coll.doc(chatId).get().then((docRef) async => {
            messageList = docRef.data()!['messages'],
            messageList.add(messageObj),
            messageList.sort((a, b) =>
                DateTime.parse(b['date']).compareTo(DateTime.parse(a['date']))),
            fullObj = {
              'lastMessage': lastMessage,
              'lastMessageDateTime': now,
              'messages': messageList
            },
            await coll.doc(chatId).set(fullObj, SetOptions(merge: true))
          });
      sendIsTexting(false);
    }
  }

  void showOtherUserTiping(Map<String, dynamic> chatObj) {
    final participantOne = chatObj['participants']['userOne']['id'];
    final amIuserOne = participantOne == firebaseAuth.currentUser!.uid;
    if (!amIuserOne) {
      isOtherTexting = chatObj['participants']['userOne']['isTyping'];
    } else {
      isOtherTexting = chatObj['participants']['userTwo']['isTyping'];
    }
  }
}
