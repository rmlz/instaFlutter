import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaflutter/app/constants.dart';
import 'package:mobx/mobx.dart';

part 'feed_store.g.dart';

class FeedStore = _FeedStoreBase with _$FeedStore;

abstract class _FeedStoreBase with Store {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;

  _FeedStoreBase(
      {required this.firebaseAuth, required this.firebaseFirestore}) {
    _loadFeed();
  }

  @observable
  Stream<QuerySnapshot>? posts = Stream.empty();

  @action
  Future<void> _loadFeed() async {
    final user = await firebaseFirestore
        .doc('${Constants.Collections.USERS}/${firebaseAuth.currentUser!.uid}')
        .get();
    final following = user.data()!['following'];

    posts = firebaseFirestore
        .collection(Constants.Collections.POSTS)
        .where('userId', whereIn: following)
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getUser(String userId) {
    return firebaseFirestore
        .doc('${Constants.Collections.USERS}/$userId')
        .get();
  }
}
