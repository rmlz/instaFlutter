import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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
    String? username;

    @observable
    String? bio;

    @observable
    bool loading = false;

    @observable
    FirebaseException? error;

    @computed
    Stream<QuerySnapshot> get posts {
        return firebaseFirestore.collection('posts')
            .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
            .orderBy('dateTime', descending: true)
            .snapshots();
    }

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
            this.bio = snapshot.data()?['bio'] as String;
            this.username = snapshot.data()?['displayName'] as String;
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
                log(displayName),
                await firebaseAuth.currentUser?.updateDisplayName(displayName).then((_) => log('Nome foi atualizado'))
            });


        }on FirebaseException catch (e) {
            error = e;
            log('ERRO', error: e);
        }
    }

    @action
    Future<void> updateProfilePicture(String filePath) async {
        loading = true;
        final userRef = await firebaseFirestore.doc('user/${user!.uid}');
        final file = File(filePath);
        final task = await firebaseStorage.ref('${user!.uid}/profilePicture.jpg').putFile(file);
        final url = await task.ref.getDownloadURL();
        
        firebaseAuth.currentUser?.updatePhotoURL(url);

        await userRef.set({
            'profilePicture': url
        }, SetOptions(merge: true));

        loading = false;
    }

    Future<void> postPicture(String filePath) async {
        loading = true;

        final userRef = await firebaseFirestore.doc('user/${user!.uid}');
        final file = File(filePath);
        final task = await firebaseStorage.ref('${user!.uid}/upload/post_${DateTime.now().millisecond}.jpg').putFile(file);
        final url = await task.ref.getDownloadURL();
        
        firebaseFirestore.collection('posts').add({
            'userId': user!.uid,
            'dateTime': DateTime.now().toIso8601String(),
            'url': url
        });
        loading = false;
    }



}