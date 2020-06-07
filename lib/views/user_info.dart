import 'package:flutter/material.dart';
import 'package:new_chat/widgets/widget.dart';
import 'converstionScreen.dart';

class UserInfoScreen extends StatelessWidget {
  final String userName;
  final String roomID;
  final String userEmail;

  const UserInfoScreen({Key key, this.userName, this.roomID, this.userEmail})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double heigh = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFF5e5b52),
      body: Container(
        child: Stack(
          children: [
            Container(
              height: heigh / 2,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.dstATop),
                  image: new NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-BSzuWpHh8QvPn2YUyA53IMzgM0qWFzRWKis50zcji3Q-WKbN&usqp=CAU"),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Container(
                width: 100.0,
                height: 100.0,
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
            Align(
              alignment: Alignment(0, .45),
              child: Container(
                height: MediaQuery.of(context).size.height * .2,
                child: Column(
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 15,
                        ),
                        Text(
                          "USA",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            roomID == null
                ? myProfile()
                : userProfileButtonToChatConversation(
                    context, userName, roomID, userEmail),
          ],
        ),
      ),
    );
  }
}
