import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/modules/login/login_store.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String title;
  const ForgotPasswordPage({Key? key, this.title = 'ForgotPasswordPage'}) : super(key: key);
  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}
class ForgotPasswordPageState extends ModularState<ForgotPasswordPage, LoginStore> {

  late TextEditingController _emailCtrl;


  @override
  Widget build(BuildContext context) {
    _emailCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: ListView(
          children: [
            Text('Não tem problema!', style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 32),),
            Text('Vamos te enviar um link para redefinir a senha...', style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 18)),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Digite o seu e-mail cadastrado'
              )
            ),
            SizedBox(height: 24),
            ElevatedButton(onPressed: () {
              store.redefinePass(email: _emailCtrl.text)
                  .then((_) {
                    showDialog(context: context, builder: (_) {
                      return AlertDialog(
                        title: Text('Email enviado'),
                        content: Text('Siga as instruções no email cadastrado'),
                        actions: [
                          ElevatedButton(onPressed: () {
                            Modular.to.pop();
                            Modular.to.pop();
                          }, child: Text('OK'))
                        ],
                      );
                    });
              });
            }, child: Text('REDEFINIR SENHA'))
          ],
        ),
      )
    );
  }
}