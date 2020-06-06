import 'package:flutter/material.dart';

import 'converstionScreen.dart';

class UserInfoScreen extends StatelessWidget {
  final String userName;
  final String roomID;
  final String userEmail;

  const UserInfoScreen({Key key, this.userName, this.roomID, this.userEmail})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5e5b52),
      appBar: AppBar(
        title: Text(userName),
        backgroundColor: Color(0xFF5e5b52),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.08,
                color: Colors.blue,
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationScreen(
                          userName: userName,
                          chatRoomID: roomID,
                          userEmail: userEmail,
                        ),
                      ),
                    );
                  },
                  child: Text("Chat"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
