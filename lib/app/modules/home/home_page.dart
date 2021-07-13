import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/constants.dart';
import 'package:mobx/mobx.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {

  @override
  void initState() {
    super.initState();
    tapMudarTela(_currentIndex);
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RouterOutlet(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: tapMudarTela,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled),
              label: 'feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search),
              label: 'pesquisa'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded),
              label: 'perfil'),


      ],
      )
    );
  }

  tapMudarTela (int index) {
      setState(() {
        _currentIndex = index;
      });
      print(Modular.to.path);
      switch (index) {
        case 0: { log('FEED ${index}'); Modular.to.navigate('/home/feed'); break; }
        case 1: { log('SEARCH ${index}'); Modular.to.navigate('/home/search'); break; }
        case 2: { log('PROFILE ${index}'); Modular.to.navigate('/home/profile'); break; }
        default: break;
      }
    }
}
