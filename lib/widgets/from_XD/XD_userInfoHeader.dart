import 'package:age/age.dart';
import 'package:flutter/material.dart';
import 'package:new_chat/services/constense.dart';
import 'package:new_chat/views/converstionScreen.dart';

class XD_userInfoHeader extends StatelessWidget {
  final String userName;
  final String userImage;
  final String userAst;
  final String userEmail;
  final AgeDuration age;
  final bool isMale;
  final String astrologyDiscribe;
  final String roomID;
  final String type;
  final String color;
  final String numbers;
  XD_userInfoHeader({
    Key key,
    this.userName,
    this.userImage,
    this.userAst,
    this.userEmail,
    this.age,
    this.isMale,
    this.astrologyDiscribe,
    this.roomID,
    this.type,
    this.color,
    this.numbers,
  }) : super(key: key);
  TextStyle textStyle() {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: isMale ? Colors.blue : Colors.pink,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Adobe XD layer: 'finland-wallpaper-b…' (shape)
        Transform.translate(
          offset: Offset(0, 0),
          child: ClipPath(
            clipper: WaveClipperTwo(flip: true),
            child: Container(
              height: 360,
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.dstATop),
                  image: NetworkImage(userImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(36.0, 255.0),
          child:
              // Adobe XD layer: 'finland-wallpaper-b…' (shape)
              Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(60.0, 60.0)),
              image: DecorationImage(
                image: NetworkImage(userImage),
                fit: BoxFit.cover,
              ),
              border: Border.all(width: 3.0, color: Colors.white),
            ),
          ),
        ),

        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: 400,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        userAst,
                        style: textStyle(),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        "البرج",
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${age.years.toString()} سنه ",
                        style: textStyle(),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        "العمر",
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        userName,
                        style: textStyle(),
                      ),
                      Text(
                        "الأسم",
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width * .9,
                color: isMale ? Colors.blue : Colors.pink,
              ),
              userEmail == Constanse.myEmail
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "نوع برجك $type",
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                "لونك المفضل $color",
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                "أرقام حظك $numbers",
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey,
                        child: FlatButton(
                          onPressed: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) => SingleChildScrollView(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(40),
                                            topLeft: Radius.circular(40),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            astrologyDiscribe,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ));
                          },
                          child: Text(
                            "شخصية برج $userAst",
                            style: TextStyle(color: Colors.white),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        userEmail == Constanse.myEmail
            ? Container()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationScreen(
                            userName: userName,
                            chatRoomID: roomID,
                            userEmail: userEmail,
                            userIMage: userImage,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0),
                          colors: [
                            Colors.greenAccent,
                            Colors.purple,
                          ],
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "محادثة",
                        style: TextStyle(fontSize: 35),
                      )),
                    ),
                  ),
                ),
              ),
        Container(
          child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 35,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              }),
        ),
      ],
    );
  }
}

class WaveClipperTwo extends CustomClipper<Path> {
  bool reverse;
  bool flip;

  WaveClipperTwo({this.reverse = false, this.flip = false});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (!reverse && !flip) {
      path.lineTo(0.0, size.height - 20);

      var firstControlPoint = Offset(size.width / 4, size.height);
      var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint =
          Offset(size.width - (size.width / 3.25), size.height - 65);
      var secondEndPoint = Offset(size.width, size.height - 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height - 40);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (!reverse && flip) {
      path.lineTo(0.0, size.height - 40);
      var firstControlPoint = Offset(size.width / 3.25, size.height - 65);
      var firstEndPoint = Offset(size.width / 1.75, size.height - 20);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondCP = Offset(size.width / 1.25, size.height);
      var secondEP = Offset(size.width, size.height - 30);
      path.quadraticBezierTo(
          secondCP.dx, secondCP.dy, secondEP.dx, secondEP.dy);

      path.lineTo(size.width, size.height - 20);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (reverse && flip) {
      path.lineTo(0.0, 20);
      var firstControlPoint = Offset(size.width / 3.25, 65);
      var firstEndPoint = Offset(size.width / 1.75, 40);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondCP = Offset(size.width / 1.25, 0);
      var secondEP = Offset(size.width, 30);
      path.quadraticBezierTo(
          secondCP.dx, secondCP.dy, secondEP.dx, secondEP.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    } else {
      path.lineTo(0.0, 20);

      var firstControlPoint = Offset(size.width / 4, 0.0);
      var firstEndPoint = Offset(size.width / 2.25, 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
      var secondEndPoint = Offset(size.width, 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
