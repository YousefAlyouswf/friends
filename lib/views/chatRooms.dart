import 'package:flutter/material.dart';
import 'package:new_chat/services/constense.dart';
import 'package:new_chat/services/helperFunctions.dart';
import 'package:new_chat/views/search.dart';
import 'package:new_chat/widgets/widget.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    Constanse.myName = await HelperFunction.getUseName();
    Constanse.myEmail = await HelperFunction.getUserEmail();
    print(Constanse.myName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5e5b52),
      appBar: appBar(context, exit: true),
     
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Search(),
              ));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
