import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  final String title;
  const ChatListPage({Key? key, this.title = 'ChatListPage'}) : super(key: key);
  @override
  ChatListPageState createState() => ChatListPageState();
}
class ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}