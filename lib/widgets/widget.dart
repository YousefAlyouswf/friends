import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_chat/services/auth.dart';
import 'package:new_chat/services/constense.dart';
import 'package:new_chat/services/database.dart';
import 'package:new_chat/services/helperFunctions.dart';
import 'package:new_chat/toggel/toggelSigninAndSignup.dart';

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
