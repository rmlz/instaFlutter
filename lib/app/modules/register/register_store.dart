import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'register_store.g.dart';

class RegisterStore = _RegisterStoreBase with _$RegisterStore;
abstract class _RegisterStoreBase with Store {

  FirebaseAuth _firebaseAuth;
  _RegisterStoreBase(this._firebaseAuth) {
    _firebaseAuth.authStateChanges().listen(_onAuthChange);
  }

  @observable
  User? user;

  @observable
  bool loading = false;

  void _onAuthChange(User? user) {
    if (user?.isAnonymous ?? true) {
      this.user = null;
    } else {
      this.user = user;
    }
  }

  @action
  Future<void> registerUser({required String name, required String email, required String password}) async {
    loading = true;
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(name);
    loading = false;
  }
}