import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;
abstract class _LoginStoreBase with Store {

  FirebaseAuth _firebaseAuth;
  _LoginStoreBase(this._firebaseAuth){

  }
  @observable
  late User? user = _firebaseAuth.currentUser;

  @action
  void _onAuthChange(User? user) {
    this.user = user;
  }

  @observable
  bool loading = false;

  @action
  Future<void> loginWith({required String email, required String password}) async {
    if (email.isEmpty || email.indexOf('@') == -1 || password.isEmpty) {
      return;
    }
    loading = true;
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    loading = false;
  }

  @action
  Future<void> redefinePass({required String email}) async {
    loading = true;
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    loading = false;
  }

}