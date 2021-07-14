import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/constants.dart';
import 'package:instaflutter/app/modules/profile/profile_store.dart';
import 'package:mobx/mobx.dart';

class ProfilePage extends StatefulWidget {
  final String title;
  const ProfilePage({Key? key, this.title = 'ProfilePage'}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ModularState<ProfilePage, ProfileStore> {
  final padding = EdgeInsets.only(left: 20, right: 16, top: 20);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ramon Barros'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.photo_camera))
        ],
      ),
      body: ListView(
        children: <Widget>[
          _topInfo(padding: padding, store: store),
          _photoGrid(padding: padding, store: store)
        ],
      ),
    );
  }
}

class _photoGrid extends StatelessWidget{
  EdgeInsets padding;
  ProfileStore store;
  _photoGrid({required this.padding, required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        childAspectRatio: 1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
          Image.network('https://picsum.photos/seed/${DateTime.now().microsecond}/200/200'),
        ],
      ),
    );
  }
}

class _topInfo extends StatelessWidget {

  ProfileStore store;
  EdgeInsets padding;
  _topInfo({required this.padding, required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding( padding: padding,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child:
                CircleAvatar(
                  radius: 48,
                  child: CircleAvatar(
                    radius: 42,
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child:
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('100', style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                              Text('Fotos', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('200', style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                              Text(
                                  'Seguindo', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('100', style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                              Text('Seguidores',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: ElevatedButton(onPressed: () {
                            log('.${Constants.Routes.EDIT_PROFILE}');
                            Modular.to.pushNamed('.${Constants.Routes.EDIT_PROFILE}');
                          },
                            child: Text('Editar Perfil'),
                          ))

                        ],
                      ),
                    ],
                  )
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Observer(builder: (_){
                  return Text(store.user?.displayName ?? 'Sem Nome', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  )
                  );
                })
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 1),
            child: Row(
              children: [
                Observer(builder: (_) {
                  return Text(store.bio ?? '',
                      style: TextStyle(
                      fontSize: 16
                  ),
                  );
                  },
                )
              ],
            ),
          )


        ],
      ),
    );
  }
}

