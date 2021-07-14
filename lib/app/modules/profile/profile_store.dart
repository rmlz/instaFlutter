import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobx/mobx.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;
abstract class _ProfileStoreBase with Store {

    FirebaseAuth firebaseAuth;
    FirebaseFirestore firebaseFirestore;
    FirebaseStorage firebaseStorage;

    _ProfileStoreBase({
        required this.firebaseAuth,
        required this.firebaseFirestore,
        required this.firebaseStorage
    }) {
        firebaseAuth.userChanges().listen(_onUserChange);
    }

    @observable
    User? user;

    @observable
    String? bio;

    @observable
    bool loading = false;

    @observable
    FirebaseException? error;

    void _onUserChange(User? user) {
        this.user = user;
        if (user != null) {
            firebaseFirestore.doc('user/${user.uid}').snapshots()
                .listen(_listenUser);
        }
    }

    @action
    void _listenUser(DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
            bio = snapshot.data()?['bio'] as String;
        }
    }

    @action
    Future<void> updateProfile({required String displayName, required String bio}) async {
        if (user == null) {
            return;
        }
        try {
            loading = true;

            await firebaseFirestore.doc('user/${user!.uid}').set({
                'displayName': displayName,
                'bio': bio
            }, SetOptions(merge: true)).then((_) async => {
                await firebaseAuth.currentUser?.updateDisplayName(displayName).then((value) => log('Nome foi atualizado'))
            });


        }on FirebaseException catch (e) {
            error = e;
            log('ERRO', error: e);
        }
    }


}