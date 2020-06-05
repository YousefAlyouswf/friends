import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String userName;

  const ConversationScreen({Key key, this.userName}) : super(key: key);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5e5b52),
        
        title: Text(widget.userName),
        centerTitle: true,
      ),
    );
  }
}
