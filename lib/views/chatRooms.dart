import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_chat/models/chatRoomModel.dart';
import 'package:new_chat/services/constense.dart';
import 'package:new_chat/services/database.dart';
import 'package:new_chat/services/helperFunctions.dart';
import 'package:new_chat/views/search.dart';
import 'package:new_chat/widgets/widget.dart';

import 'converstionScreen.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

Stream chatRommStream;

class _ChatRoomsState extends State<ChatRooms> {
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    Constanse.myName = await HelperFunction.getUseName();
    Constanse.myEmail = await HelperFunction.getUserEmail();
    setState(() {});
    print(Constanse.myName);
  }

 

  Widget getConversationChat() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('chat')
          .where("users", arrayContains: Constanse.myName)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            'No Data...',
          );
        } else {
          List<ChatRoomModel> userNames = new List();
          for (var i = 0; i < snapshot.data.documents.length; i++) {
            for (var j = 0;
                j < snapshot.data.documents[i].data['users'].length;
                j++) {
              String user = snapshot.data.documents[i].data['users'][j];
              if (user != Constanse.myName) {
                userNames.add(ChatRoomModel(
                  user,
                  snapshot.data.documents[i].data['lastMsg'],
                  snapshot.data.documents[i].data['time'],
                ));
              }
            }
          }
          userNames.sort((b, a) => a.time.compareTo(b.time));
          print(userNames);
          return ListView.builder(
            itemCount: userNames.length,
            itemBuilder: (context, i) {
              return ChatConversation(
                userName: userNames[i].userName,
                message: userNames[i].lastMsg,
                
              );
            },
          );
        }
      },
    );
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
      body: Container(
        child: getConversationChat(),
      ),
    );
  }
}

class ChatConversation extends StatelessWidget {
  final String message;
  final String userName;
  const ChatConversation({Key key, this.message, this.userName})
      : super(key: key);
 getChatRoomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  startConversation(String userName, BuildContext context) {
    String roomID = getChatRoomID(userName, Constanse.myName);
    List<String> users = [userName, Constanse.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "roomID": roomID,
      "lastMsg": "",
      "time": "",
    };

    Database().createChatRoom(roomID, chatRoomMap);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(
          userName: userName,
          chatRoomID: roomID,

        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: ListTile(
        onTap: (){
          startConversation(userName, context);
        },
        title: Text(
          userName,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        leading: Container(
          width: 60.0,
          height: 60.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: new NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-BSzuWpHh8QvPn2YUyA53IMzgM0qWFzRWKis50zcji3Q-WKbN&usqp=CAU"),
            ),
          ),
        ),
      ),
    );
  }
}
