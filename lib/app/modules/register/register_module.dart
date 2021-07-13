import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaflutter/app/modules/register/register_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'register_page.dart';

class RegisterModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RegisterStore(i.get<FirebaseAuth>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (context, args) => RegisterPage()),
  ];
}
