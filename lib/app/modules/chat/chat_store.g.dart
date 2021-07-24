// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatStore on _ChatStoreBase, Store {
  final _$chatIdAtom = Atom(name: '_ChatStoreBase.chatId');

  @override
  String? get chatId {
    _$chatIdAtom.reportRead();
    return super.chatId;
  }

  @override
  set chatId(String? value) {
    _$chatIdAtom.reportWrite(value, super.chatId, () {
      super.chatId = value;
    });
  }

  final _$userListAtom = Atom(name: '_ChatStoreBase.userList');

  @override
  Stream<QuerySnapshot<Object?>>? get userList {
    _$userListAtom.reportRead();
    return super.userList;
  }

  @override
  set userList(Stream<QuerySnapshot<Object?>>? value) {
    _$userListAtom.reportWrite(value, super.userList, () {
      super.userList = value;
    });
  }

  final _$chatListAtom = Atom(name: '_ChatStoreBase.chatList');

  @override
  Stream<DocumentSnapshot<Object?>> get chatList {
    _$chatListAtom.reportRead();
    return super.chatList;
  }

  @override
  set chatList(Stream<DocumentSnapshot<Object?>> value) {
    _$chatListAtom.reportWrite(value, super.chatList, () {
      super.chatList = value;
    });
  }

  final _$isOtherTextingAtom = Atom(name: '_ChatStoreBase.isOtherTexting');

  @override
  bool get isOtherTexting {
    _$isOtherTextingAtom.reportRead();
    return super.isOtherTexting;
  }

  @override
  set isOtherTexting(bool value) {
    _$isOtherTextingAtom.reportWrite(value, super.isOtherTexting, () {
      super.isOtherTexting = value;
    });
  }

  final _$loadUserAsyncAction = AsyncAction('_ChatStoreBase.loadUser');

  @override
  Future<void> loadUser() {
    return _$loadUserAsyncAction.run(() => super.loadUser());
  }

  final _$loadUserListAsyncAction = AsyncAction('_ChatStoreBase.loadUserList');

  @override
  Future<void> loadUserList() {
    return _$loadUserListAsyncAction.run(() => super.loadUserList());
  }

  final _$createOrLoadChatAsyncAction =
      AsyncAction('_ChatStoreBase.createOrLoadChat');

  @override
  Future<void> createOrLoadChat() {
    return _$createOrLoadChatAsyncAction.run(() => super.createOrLoadChat());
  }

  @override
  String toString() {
    return '''
chatId: ${chatId},
userList: ${userList},
chatList: ${chatList},
isOtherTexting: ${isOtherTexting}
    ''';
  }
}
