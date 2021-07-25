import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instamon/app/constants.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'register_store.g.dart';

class RegisterStore = _RegisterStoreBase with _$RegisterStore;

abstract class _RegisterStoreBase with Store {
  FirebaseAuth _firebaseAuth;
  FirebaseFirestore _firebaseFirestore;
  SharedPreferences _sharedPreferences;
  _RegisterStoreBase(
      this._firebaseAuth, this._sharedPreferences, this._firebaseFirestore) {
    _firebaseAuth.authStateChanges().listen(_onAuthChange);
  }

  @observable
  User? user;

  @observable
  bool loading = false;

  @action
  void _onAuthChange(User? user) {
    if (user?.isAnonymous ?? true) {
      //elvis operator
      this.user = null;
    } else {
      this.user = user;
    }
  }

  @action
  Future<void> registerUser(
      {required String name,
      required String email,
      required String password}) async {
    loading = true;
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(name);
    _sharedPreferences.setBool(Constants.SPK_REGISTER_DONE, true);
    await _firebaseFirestore
        .doc('${Constants.Collections.USERS}/${user!.uid}')
        .set({
      'displayName': name,
      'following': [],
      'followers': [],
      'profilePicture': null,
      'id': user!.uid
    });

    loading = false;
  }
}
