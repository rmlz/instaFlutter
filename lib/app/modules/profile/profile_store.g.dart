// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileStore on _ProfileStoreBase, Store {
  Computed<Stream<QuerySnapshot<Object?>>>? _$postsComputed;

  @override
  Stream<QuerySnapshot<Object?>> get posts => (_$postsComputed ??=
          Computed<Stream<QuerySnapshot<Object?>>>(() => super.posts,
              name: '_ProfileStoreBase.posts'))
      .value;

  final _$userAtom = Atom(name: '_ProfileStoreBase.user');

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$usernameAtom = Atom(name: '_ProfileStoreBase.username');

  @override
  String? get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String? value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  final _$bioAtom = Atom(name: '_ProfileStoreBase.bio');

  @override
  String? get bio {
    _$bioAtom.reportRead();
    return super.bio;
  }

  @override
  set bio(String? value) {
    _$bioAtom.reportWrite(value, super.bio, () {
      super.bio = value;
    });
  }

  final _$followingAtom = Atom(name: '_ProfileStoreBase.following');

  @override
  int? get following {
    _$followingAtom.reportRead();
    return super.following;
  }

  @override
  set following(int? value) {
    _$followingAtom.reportWrite(value, super.following, () {
      super.following = value;
    });
  }

  final _$followersAtom = Atom(name: '_ProfileStoreBase.followers');

  @override
  int? get followers {
    _$followersAtom.reportRead();
    return super.followers;
  }

  @override
  set followers(int? value) {
    _$followersAtom.reportWrite(value, super.followers, () {
      super.followers = value;
    });
  }

  final _$postCountAtom = Atom(name: '_ProfileStoreBase.postCount');

  @override
  int? get postCount {
    _$postCountAtom.reportRead();
    return super.postCount;
  }

  @override
  set postCount(int? value) {
    _$postCountAtom.reportWrite(value, super.postCount, () {
      super.postCount = value;
    });
  }

  final _$loadingAtom = Atom(name: '_ProfileStoreBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$errorAtom = Atom(name: '_ProfileStoreBase.error');

  @override
  FirebaseException? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(FirebaseException? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$updateProfileAsyncAction =
      AsyncAction('_ProfileStoreBase.updateProfile');

  @override
  Future<void> updateProfile(
      {required String displayName, required String bio}) {
    return _$updateProfileAsyncAction
        .run(() => super.updateProfile(displayName: displayName, bio: bio));
  }

  final _$updateProfilePictureAsyncAction =
      AsyncAction('_ProfileStoreBase.updateProfilePicture');

  @override
  Future<void> updateProfilePicture(String filePath) {
    return _$updateProfilePictureAsyncAction
        .run(() => super.updateProfilePicture(filePath));
  }

  final _$postPictureAsyncAction = AsyncAction('_ProfileStoreBase.postPicture');

  @override
  Future<void> postPicture(String filePath) {
    return _$postPictureAsyncAction.run(() => super.postPicture(filePath));
  }

  final _$_ProfileStoreBaseActionController =
      ActionController(name: '_ProfileStoreBase');

  @override
  void _listenUser(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase._listenUser');
    try {
      return super._listenUser(snapshot);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> logout() {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase.logout');
    try {
      return super.logout();
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPostCount(int count) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase.setPostCount');
    try {
      return super.setPostCount(count);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
username: ${username},
bio: ${bio},
following: ${following},
followers: ${followers},
postCount: ${postCount},
loading: ${loading},
error: ${error},
posts: ${posts}
    ''';
  }
}
