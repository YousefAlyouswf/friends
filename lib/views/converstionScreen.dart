import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_chat/services/constense.dart';
import 'package:new_chat/services/database.dart';

class ConversationScreen extends StatefulWidget {
  final String userName;
  final String chatRoomID;
  const ConversationScreen({Key key, this.userName, this.chatRoomID})
      : super(key: key);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController _msg = TextEditingController();
  Widget chatMsgList() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('chat')
            .document(widget.chatRoomID)
            .collection('chatmsg')
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              'No Data...',
            );
          } else {
            return ListView.builder(
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
                });
          }
        });
  }

  sendMssages() {
    if (_msg.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "msg": _msg.text,
        "sendBy": Constanse.myName,
        "time": DateTime.now().toUtc()
      };
      Database().sendTextChat(widget.chatRoomID, messageMap);
      Database().setLastMsg(widget.chatRoomID, _msg.text,DateTime.now().toUtc().millisecondsSinceEpoch);
      _msg.clear();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5e5b52),
      appBar: AppBar(
        backgroundColor: Color(0xFF5e5b52),
        title: Text(widget.userName),
        centerTitle: true,
      ),
      body: Container(
        child: Stack(
          children: [
            chatMsgList(),
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
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            size: 30,
                          ),
                          onPressed: sendMssages,
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
                  )),
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
                  )),
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
