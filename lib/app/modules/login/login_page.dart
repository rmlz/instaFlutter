import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/constants.dart';
import 'package:mobx/mobx.dart';

import 'login_store.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key? key, this.title = 'LoginPage'}) : super(key: key);
  @override
  LoginPageState createState() => LoginPageState();
}
class LoginPageState extends ModularState<LoginPage, LoginStore> {

  late TextEditingController _emailCtrl;
  late TextEditingController _passwordController;
  late final ReactionDisposer _disposer;

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  @override
  void initState() {
    _disposer = when(
        (_) => store.user != null,
        () => Modular.to.pushReplacementNamed(Constants.Routes.HOME)
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _emailCtrl = TextEditingController();
    _passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            child: Text('Cadastre-se'),
            onPressed: () {
              Modular.to.pushNamed(Constants.Routes.REGISTER);
            }
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: _emailCtrl,
              decoration: InputDecoration(
                labelText: "E-mail:",
                hintText: "seuemail@hotmail.com"
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Senha",
              ),
            ),
            SizedBox(height:10),
            ElevatedButton(onPressed: () {
              store.loginWith(
                  email: _emailCtrl.text,
                  password: _passwordController.text
              );
            }, child: Observer(
              builder: (ctx) {
                if (store.loading){
                  return Transform.scale(
                      scale: 0.5, child: CircularProgressIndicator(
                      color: Theme.of(ctx).buttonColor)
                  );
                }
                return Text("Entrar");
              }
            )),
            ElevatedButton(onPressed: () {
              Modular.to.navigate(Constants.Routes.FORGOT_PASSWORD);
            }, child: Text('Esqueci a senha'))
          ],
        ),
      ),
    );
  }
}