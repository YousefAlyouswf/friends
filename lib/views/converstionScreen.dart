import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_chat/services/constense.dart';
import 'package:new_chat/services/database.dart';
import 'package:new_chat/views/user_info_test.dart';

class ConversationScreen extends StatefulWidget {
  final String userName;
  final String chatRoomID;
  final String userEmail;
  final String userIMage;
  final bool isMale;
  const ConversationScreen(
      {Key key,
      this.userName,
      this.chatRoomID,
      this.userEmail,
      this.userIMage,
      this.isMale})
      : super(key: key);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  int showMsg = 20;
  bool showBtnReload = false;
  ScrollController _scrollController = new ScrollController();
  TextEditingController _msg = TextEditingController();

  loadMore() {
    setState(() {
      showMsg += 20;
       showBtnReload = !showBtnReload;
    });
  }

  showBtn() {
    setState(() {
      showBtnReload = !showBtnReload;
    });
  }

  Widget chatMsgList() {
    return Padding(
      padding: EdgeInsets.only(bottom: 100),
      child: Container(
        height: MediaQuery.of(context).size.height * .75,
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .document(widget.chatRoomID)
                .collection('chatmsg')
                .orderBy('time', descending: true)
                .limit(showMsg)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text(
                  'No Data...',
                );
              } else {
                return Column(
                  children: [
                    showBtnReload
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white24,
                            child: FlatButton(
                              onPressed: loadMore,
                              child: Text("عرض المزيد"),
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, i) {
                            bool isMe;
                            if (snapshot.data.documents[i].data['sendBy'] ==
                                Constanse.myName) {
                              isMe = true;
                            } else {
                              isMe = false;
                            }

                            return MsgTile(
                              message: snapshot.data.documents[i].data['msg'],
                              isMe: isMe,
                            );
                          }),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
        } else {
          showBtn();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5e5b52),
      appBar: AppBar(
        backgroundColor: Color(0xFF5e5b52),
        title: Text(widget.userName),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoTestScreen(
                      userName: widget.userName,
                      roomID: widget.chatRoomID,
                      userEmail: widget.userEmail,
                      userImage: widget.userIMage,
                      dobAndMale: false,
                    ),
                  ),
                );
              },
              child: Container(
                width: 40.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(widget.userIMage != null
                        ? widget.userIMage
                        : "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-BSzuWpHh8QvPn2YUyA53IMzgM0qWFzRWKis50zcji3Q-WKbN&usqp=CAU"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            chatMsgList(),
            //كتابة الرساله وارسالها الى الصديق
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: Colors.grey[600],
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _msg,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            hintText: "الرسالة",
                            hintStyle: TextStyle(color: Colors.white60),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Icon(
                              Icons.send,
                              size: 30,
                            ),
                            onPressed: () async {
                              await sendMessage().then((v) {
                                if (v) {
                                  _msg.clear();
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      'the user blocked you',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    backgroundColor: Colors.red[300],
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> sendMessage() async {
    bool blockedMe = false;
    if (_msg.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "msg": _msg.text,
        "sendBy": Constanse.myName,
        "time": DateTime.now().toUtc()
      };

      await Firestore.instance
          .collection('users')
          .where("email", isEqualTo: widget.userEmail)
          .getDocuments()
          .then((v) {
        v.documents.forEach((result) async {
          for (var i = 0; i < result['blockList'].length; i++) {
            String email = result['blockList'][i];
            if (email == Constanse.myEmail) {
              blockedMe = true;
            }
          }
          if (blockedMe) {
          } else {
            await Database().setLastMsg(widget.chatRoomID, _msg.text,
                DateTime.now().toUtc().millisecondsSinceEpoch);
            await Firestore.instance
                .collection('chat')
                .document(widget.chatRoomID)
                .collection('chatmsg')
                .add(messageMap);
          }
        });
      });
    }
    if (blockedMe) {
      return false;
    } else {
      return true;
    }
  }
}

class MsgTile extends StatelessWidget {
  final String message;
  final bool isMe;
  const MsgTile({Key key, this.message, this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMe
        ? Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Text(
                message,
                textAlign: TextAlign.end,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          )
        : Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Text(
                message,
                textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          );
  }
}
