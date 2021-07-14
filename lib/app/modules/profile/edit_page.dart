import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/modules/profile/profile_module.dart';
import 'package:instaflutter/app/modules/profile/profile_store.dart';

class EditPage extends StatefulWidget {
  final String title;
  const EditPage({Key? key, this.title = 'EditPage'}) : super(key: key);
  @override
  EditPageState createState() => EditPageState();
}
class EditPageState extends ModularState<EditPage, ProfileStore> {

  late final TextEditingController _nameController;
  late final TextEditingController _bioController;


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: store.user?.displayName);
    _bioController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        actions: [
          Observer(builder: (_) {
            if (store.loading){
              return Container(
                child: Center(
                  child: Transform.scale(
                      scale: 0.5,
                  child: CircularProgressIndicator(color: Theme.of(context).buttonColor
                  )
                  ),
                ),
              );
            }
            return TextButton(
                onPressed: () {
                  store.updateProfile(displayName: _nameController.text, bio: _bioController.text);
                  Modular.to.pop();
                },
                child: Text('Concluir',
                  style: TextStyle(color: Theme.of(context).buttonColor, fontWeight: FontWeight.bold),));
          })
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 24),
          CircleAvatar(
            radius: 48,
            child: CircleAvatar(
              radius: 42,
              backgroundImage: AssetImage('assets/user.png'),
            ),
          ),
        TextButton(onPressed: () {}, child: Text('Alterar foto de perfil')),
          _EditField(label: 'Nome:', controller: _nameController, maxLength: 30,),
          _EditField(label: 'Bio:', controller: _bioController, maxLength: 150,),

        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {

  String label;
  TextEditingController controller;
  int? maxLength;

  _EditField({required this.label, required this.controller, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold),),
        ),
          SizedBox(width: 12,),
          Flexible(child: Container(
            child: TextFormField(
              controller: controller,
              minLines: 1,
              maxLines: 10,
              decoration: InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
              ),
              maxLength: maxLength,
              style: TextStyle(fontSize: 14),
            ),
          ))
        ],
      ),
    );
  }
}