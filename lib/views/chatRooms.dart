import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_chat/models/chatRoomModel.dart';
import 'package:new_chat/services/constense.dart';
import 'package:new_chat/services/database.dart';
import 'package:new_chat/services/helperFunctions.dart';
import 'package:new_chat/views/search.dart';
import 'package:new_chat/views/user_info.dart';
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
    Constanse.myImage = await HelperFunction.getUserImage();
    setState(() {});
  }

  Widget getConversationChat() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('chat')
          .where("emails", arrayContains: Constanse.myEmail)
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
              String emails = snapshot.data.documents[i].data['emails'][j];
              String image = snapshot.data.documents[i].data['image'][j];
              if (emails != Constanse.myEmail) {
                userNames.add(ChatRoomModel(
                  user,
                  snapshot.data.documents[i].data['lastMsg'],
                  snapshot.data.documents[i].data['time'],
                  emails,
                  snapshot.data.documents[i].data['roomID'],
                  image,
                ));
              }
            }
          }
          userNames.sort((b, a) => a.time.compareTo(b.time));
          print(userNames);
          return ListView.builder(
            itemCount: userNames.length,
            itemBuilder: (context, i) {
              return userNames[i].lastMsg == ""
                  ? Container()
                  : ChatConversation(
                      userName: userNames[i].userName,
                      message: userNames[i].lastMsg,
                      userEmail: userNames[i].userEmail,
                      roomID: userNames[i].roomID,
                      userImage: userNames[i].userImage,
                    );
            },
          );
        }
      },
    );
  }

  List<String> drawerMenu = ["Profile", "Setting"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5e5b52),
      appBar: appBar(context, exit: true, noLogo: true),
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
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .3,
              color: Color(0xFF5e5b52),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(Constanse.myImage != null
                              ? Constanse.myImage
                              : "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-BSzuWpHh8QvPn2YUyA53IMzgM0qWFzRWKis50zcji3Q-WKbN&usqp=CAU"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Constanse.myName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                        Text("Regular Member",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                    itemCount: drawerMenu.length,
                    itemBuilder: (BuildContext ctxt, int i) {
                      return ListTile(
                        onTap: () {
                          if (i == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserInfoScreen(
                                  userName: Constanse.myName,
                                  userEmail: Constanse.myEmail,
                                ),
                              ),
                            );
                          }
                        },
                        title: Text(drawerMenu[i]),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
      body: Container(
        child: getConversationChat(),
      ),
    );
  }
}

class ChatConversation extends StatefulWidget {
  final String message;
  final String userName;
  final String userEmail;
  final String roomID;
  final String userImage;
  const ChatConversation(
      {Key key,
      this.message,
      this.userName,
      this.userEmail,
      this.roomID,
      this.userImage})
      : super(key: key);

  @override
  _ChatConversationState createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  getChatRoomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  startConversation(String userEmail, String userName, BuildContext context) {
    String roomID = getChatRoomID(userEmail, Constanse.myEmail);
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
          userEmail: userEmail,
          userIMage: widget.userImage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: ListTile(
        onTap: () {
          startConversation(widget.userEmail, widget.userName, context);
        },
        onLongPress: () async {
          bool blocked = false;
          await Firestore.instance
              .collection('users')
              .where("email", isEqualTo: Constanse.myEmail)
              .getDocuments()
              .then((v) {
            v.documents.forEach((result) async {
              for (var i = 0; i < result['blockList'].length; i++) {
                String email = result['blockList'][i];
                if (email == widget.userEmail) {
                  blocked = true;
                }
              }

              AlertDialog alert = AlertDialog(
                  title: Text(widget.userName),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserInfoScreen(
                                  userName: widget.userName,
                                  roomID: widget.roomID,
                                  userEmail: widget.userEmail,
                                ),
                              ),
                            ).then((value) => Navigator.pop(context));
                          },
                          child: Text("View")),
                      FlatButton(
                          onPressed: () => blockButton(blocked),
                          child: Text(blocked ? "Unblock" : "Block")),
                      FlatButton(onPressed: () {}, child: Text("Delete"))
                    ],
                  ));

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            });
          });
        },
        title: Text(
          widget.userName,
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        subtitle: Text(
          widget.message,
          style: TextStyle(color: Colors.white),
        ),
        leading: Container(
          width: 60.0,
          height: 60.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: new NetworkImage(widget.userImage != null
                  ? widget.userImage
                  : "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-BSzuWpHh8QvPn2YUyA53IMzgM0qWFzRWKis50zcji3Q-WKbN&usqp=CAU"),
            ),
          ),
        ),
      ),
    );
  }

  blockButton(bool blocked) {
    Database().getUserID(widget.userEmail).then((v) {
      v.documents.forEach((result) {
        if (blocked) {
          Database().removeFromBlockList(widget.userEmail, result.documentID);
        } else {
          Database().addToBlockList(widget.userEmail, result.documentID);
        }
      });
    });
    Navigator.pop(context);
  }
}
