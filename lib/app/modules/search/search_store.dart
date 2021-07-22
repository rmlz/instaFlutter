import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaflutter/app/constants.dart';
import 'package:mobx/mobx.dart';

part 'search_store.g.dart';

class SearchStore = _SearchStoreBase with _$SearchStore;

abstract class _SearchStoreBase with Store {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  _SearchStoreBase(
      {required this.firebaseAuth, required this.firebaseFirestore});

  @observable
  Stream<QuerySnapshot> searchResult = Stream.empty();

  @action
  Future<void> search(String query) async {
    if (query.isNotEmpty) {
      searchResult = firebaseFirestore
          .collection(Constants.Collections.USERS)
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName',
              isNotEqualTo: firebaseAuth.currentUser!.displayName)
          .snapshots();
    } else {
      searchResult = Stream.empty();
    }
  }

  @computed
  Stream<QuerySnapshot> get posts {
    return firebaseFirestore
        .collection(Constants.Collections.POSTS)
        .where('userId', isNotEqualTo: firebaseAuth.currentUser!.uid)
        .snapshots();
  }

  @action
  Future<void> add(String userId) async {
    final addingUser =
        firebaseFirestore.doc('user/${firebaseAuth.currentUser!.uid}');
    final addedUser = firebaseFirestore.doc('user/$userId');

    final addingUserData =
        (await addingUser.get()).data() as Map<String, dynamic>;
    final following = addingUserData.containsKey('following')
        ? addingUserData['following'] as List<dynamic>
        : [];

    following.add(userId);

    addingUser.set(
        {'following': following.toSet().toList()}, SetOptions(merge: true));

    final addedUserData =
        (await addedUser.get()).data() as Map<String, dynamic>;
    final followers = addedUserData.containsKey('followers')
        ? addedUserData['followers'] as List<dynamic>
        : [];

    followers.add(firebaseAuth.currentUser!.uid);

    addedUser.set(
        {'followers': followers.toSet().toList()}, SetOptions(merge: true));
  }
}
