import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_chat/services/auth.dart';
import 'package:new_chat/services/constense.dart';
import 'package:new_chat/services/database.dart';
import 'package:new_chat/services/helperFunctions.dart';
import 'package:new_chat/toggel/toggelSigninAndSignup.dart';
import 'package:new_chat/views/converstionScreen.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

String appName = "";
userLang() async {
  appName = await HelperFunction.getUserLang();
}

Widget appBar(
  BuildContext context, {
  bool exit = false,
  bool stream = false,
  Function toggle,
  bool noLogo = false,
  bool reload = false,
  Function reloading,
}) {
  userLang();
  return AppBar(
    backgroundColor: Color(0xFF5e5b52),
    centerTitle: exit ? true : false,
    title: exit
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              noLogo
                  ? Container()
                  : Image.network(
                      "https://www.pinclipart.com/picdir/big/54-546980_sms-transparent-sms-blue-icon-png-clipart.png",
                      fit: BoxFit.fitWidth,
                      height: 50,
                    ),
              SizedBox(
                width: 10,
              ),
              Text(appName == "ar" ? "الأصدقاء" : "Friends"),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(appName == "ar" ? "الأصدقاء" : "Friends"),
              noLogo
                  ? Container()
                  : Image.network(
                      "https://www.pinclipart.com/picdir/big/54-546980_sms-transparent-sms-blue-icon-png-clipart.png",
                      fit: BoxFit.fitWidth,
                      height: 50,
                    ),
            ],
          ),
    actions: [
      reload
          ? IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: reloading)
          : Container(),
      exit
          ? IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                HelperFunction.saveUserLoggedIn(false);
                AuthMethod().signOut();

                Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new ToggleSigninAndSignup(),
                  ),
                );

                Database().updateLoginedToFlase(Constanse.myEmail);
              },
            )
          : Container(),
      stream
          ? IconButton(
              icon: Icon(Icons.view_stream),
              onPressed: toggle,
            )
          : Container()
    ],
  );
}

TextFormField textField(String label, String hint, TextInputType textInputType,
    TextEditingController controller, IconData icon,
    [bool password = false]) {
  return TextFormField(
    controller: controller,
    textAlign: TextAlign.end,
    keyboardType: textInputType,
    obscureText: password,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      suffixIcon: Icon(
        icon,
      ),
      prefix: IconButton(
          icon: Icon(Icons.clear, color: Colors.white),
          onPressed: () {
            controller.clear();
          }),
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Colors.white54),
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
  );
}

Text simpleTextStyle(String text, [bool isForClick = false]) {
  return Text(
    text,
    textDirection: TextDirection.rtl,
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
      decoration: isForClick ? TextDecoration.underline : TextDecoration.none,
    ),
    textAlign: TextAlign.end,
  );
}

Container buttonsSings(BuildContext context, String text, bool isSignin) {
  return Container(
    margin: EdgeInsets.all(8),
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.symmetric(
      vertical: 20,
    ),
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
            colors: isSignin
                ? [Colors.blue, Colors.blue[200]]
                : [Colors.white, Colors.blue[50]])),
    child: Text(
      text,
      style: TextStyle(
          color: isSignin ? Colors.white : Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.bold),
    ),
  );
}

void fluttertoastWarning(String text, [bool long = false]) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

Container myProfile() {
  return Container();
}

Container userProfileButtonToChatConversation(
    BuildContext context,
    String userName,
    String roomID,
    String userEmail,
    String userImage,
    bool isMale) {
  return Container(
    alignment: Alignment.bottomCenter,
    child: ClipPath(
      clipper: OvalTopBorderClipper(),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: new BoxDecoration(
          color: isMale ? Colors.blue : Colors.pink,
        ),
        child: FlatButton(
            onPressed: () {
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
            child: Icon(Icons.message, color: Colors.white, size: 50)),
      ),
    ),
  );
}

Align userinfo(BuildContext context, String userName, bool isMale, String age,
    String astrology, String astrologyDiscribe) {
  return Align(
    alignment: Alignment(0, .6),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * .25,
        child: Card(
          elevation: 5,
          color: Colors.transparent,
          child: Column(
            children: [
              Text(
                userName,
                style: TextStyle(
                    color: isMale ? Colors.blue : Colors.pink,
                    fontSize: 36,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    age,
                    style: TextStyle(
                        color: isMale ? Colors.blue : Colors.pink,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => SingleChildScrollView(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: isMale
                                        ? Colors.blue[100]
                                        : Colors.pink[100],
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
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(
                        10,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 6.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: isMale
                              ? [Colors.white, Colors.blueGrey[600]]
                              : [Colors.white, Colors.pinkAccent[200]],
                        ),
                      ),
                      child: Text(
                        astrology,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Align myImageProfile(Function choosrImageSource, String image) {
  return Align(
    alignment: Alignment(0, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: choosrImageSource,
          child: Container(
            width: 100.0,
            height: 100.0,
            decoration: new BoxDecoration(
              border: Border.all(
                width: 3.5,
                color: Color(0xFF5e5b52),
              ),
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(
                  image == ""
                      ? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-BSzuWpHh8QvPn2YUyA53IMzgM0qWFzRWKis50zcji3Q-WKbN&usqp=CAU"
                      : image,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Align userImageProfile(String image) {
  return Align(
    alignment: Alignment(0, 0),
    child: Container(
      width: 100.0,
      height: 100.0,
      decoration: new BoxDecoration(
        border: Border.all(
          width: 3.5,
          color: Color(0xFF5e5b52),
        ),
        shape: BoxShape.circle,
        image: new DecorationImage(
          fit: BoxFit.fill,
          image: new NetworkImage(
            image == ""
                ? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-BSzuWpHh8QvPn2YUyA53IMzgM0qWFzRWKis50zcji3Q-WKbN&usqp=CAU"
                : image,
          ),
        ),
      ),
    ),
  );
}

Container bigImage(double heigh, String image) {
  return Container(
    height: heigh / 2,
    decoration: new BoxDecoration(
      image: new DecorationImage(
        fit: BoxFit.fill,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
        image: new NetworkImage(
          image == ""
              ? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-BSzuWpHh8QvPn2YUyA53IMzgM0qWFzRWKis50zcji3Q-WKbN&usqp=CAU"
              : image,
        ),
      ),
    ),
  );
}

Align cameraIcon(bool imageSourceVisible, Function _takePicture) {
  return Align(
    alignment: Alignment(0.5, 0.2),
    child: Visibility(
      visible: imageSourceVisible,
      child: InkWell(
        onTap: _takePicture,
        child: Icon(
          Icons.camera,
          size: 60,
          color: Colors.pink,
        ),
      ),
    ),
  );
}

Align galaryIcon(bool imageSourceVisible, Function _takeFromGalary) {
  return Align(
    alignment: Alignment(-0.5, 0.2),
    child: Visibility(
      visible: imageSourceVisible,
      child: InkWell(
        onTap: _takeFromGalary,
        child: Icon(
          Icons.image,
          size: 60,
          color: Colors.pink,
        ),
      ),
    ),
  );
}
