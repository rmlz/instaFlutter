import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instamon/app/constants.dart';
import 'package:instamon/app/modules/profile/profile_page.dart';
import 'package:instamon/app/modules/profile/profile_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instamon/app/modules/profile/edit_page.dart';

class ProfileModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ProfileStore(
        firebaseAuth: i.get<FirebaseAuth>(),
        firebaseFirestore: i.get<FirebaseFirestore>(),
        firebaseStorage: i.get<FirebaseStorage>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ProfilePage()),
    ChildRoute(Constants.Routes.EDIT_PROFILE,
        child: (_, args) => EditPage(), transition: TransitionType.downToUp),
  ];
}
