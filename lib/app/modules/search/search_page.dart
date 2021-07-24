import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/modules/search/search_store.dart';

class SearchPage extends StatefulWidget {
  final String title;
  const SearchPage({Key? key, this.title = 'Buscar Pessoas'}) : super(key: key);
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends ModularState<SearchPage, SearchStore> {
  bool _searching = false;
  late final TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(() {
      final query = _searchController.text;
      store.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _searching ? _searchField() : Text(widget.title),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _searching = !_searching;
                    _searchController.text = '';
                  });
                },
                icon: Icon(!_searching ? Icons.search : Icons.search_off))
          ],
        ),
        body: _searching ? _isSearching : _notSearching);
  }

  Widget _searchField() {
    final color = Theme.of(context).buttonColor;
    return TextFormField(
      decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            color: color,
          ),
          fillColor: color,
          focusColor: color,
          hoverColor: color),
      cursorColor: color,
      style: TextStyle(color: color),
      controller: _searchController,
    );
  }

  late Widget _notSearching = StreamBuilder(
      stream: store.posts,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          log('Erro ao carregar');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: Transform.scale(
                  scale: 0.5,
                  child: CircularProgressIndicator(
                      color: Theme.of(context).buttonColor)),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data!.docs.length > 0) {
          final posts = snapshot.data!.docs;
          return GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1,
              children: posts.map(
                (post) {
                  final data = post.data() as Map<String, dynamic>;
                  return Image.network(
                    data['url'] as String,
                    fit: BoxFit.cover,
                  );
                },
              ).toList());
        }
        return Container(
          child: Text("DEU PAU!"),
        );
      });

  late Widget _isSearching = Observer(builder: (_) {
    return StreamBuilder(
        stream: store.searchResult,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            log('Erro ao carregar');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator(
                        color: Theme.of(context).buttonColor)),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data!.docs.length > 0) {
            final users = snapshot.data!.docs;
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, index) {
                  final user = users[index];
                  final userMap = user.data() as Map<String, dynamic>;
                  final containPic = userMap.containsKey('profilePicture');

                  return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: InkWell(
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 32,
                                backgroundImage: containPic
                                    ? NetworkImage(user['profilePicture'])
                                    : AssetImage('assets/user.png')
                                        as ImageProvider),
                            SizedBox(
                              width: 16,
                            ),
                            Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width -
                                      24 -
                                      72 -
                                      12,
                                  child: Text(user['displayName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      )),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width -
                                        24 -
                                        72 -
                                        12,
                                    child: Text(
                                      user['bio'],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ))
                              ],
                            )
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final name = user['displayName'];
                              return AlertDialog(
                                title: Text(name),
                                content: Text(
                                    'Deseja adicionar $name aos seus amigos?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Não')),
                                  ElevatedButton(
                                      onPressed: () {
                                        store.add(user.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Sim')),
                                ],
                              );
                            },
                          );
                        },
                      ));
                });
          }
          return Container(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Digite algo no campo de busca acima!"),
                Transform.scale(scale: 0.8, child: CircularProgressIndicator()),
              ],
            )),
          );
        });
  });
}
