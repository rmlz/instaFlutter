import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/modules/home/home_store.dart';

class FeedPage extends StatefulWidget {
  final String title;
  const FeedPage({Key? key, this.title = 'FeedPage'}) : super(key: key);
  @override
  FeedPageState createState() => FeedPageState();
}
class FeedPageState extends ModularState<FeedPage, HomeStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Text('FEED', style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 32)
          )],
      ),
    );
  }
}