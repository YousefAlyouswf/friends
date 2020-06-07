import 'package:flutter/material.dart';
import 'package:new_chat/services/auth.dart';
import 'package:new_chat/services/database.dart';
import 'package:new_chat/services/helperFunctions.dart';
import 'package:new_chat/views/forgotpassword.dart';
import 'package:new_chat/widgets/widget.dart';
import 'chatRooms.dart';

class Signin extends StatefulWidget {
  final Function toggle;

  const Signin({Key key, this.toggle}) : super(key: key);
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthMethod _authMethod = new AuthMethod();
  bool isloading = false;
  signMe() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      fluttertoastWarning("يجب ملئ جميع الحقول");
    } else {
      _authMethod
          .signinWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) async {
        if (value == "ERROR_USER_NOT_FOUND") {
          fluttertoastWarning("الإيميل غير مسجل يمكنك التسجيل الان");
        } else if (value == "ERROR_INVALID_EMAIL") {
          fluttertoastWarning("الإيميل غير صحيح");
        } else if (value == "ERROR_WRONG_PASSWORD") {
          fluttertoastWarning("كلمة المرور غير صحيحه");
        } else {
          setState(() {
            isloading = true;
          });
          Database().updateLoginedToTrue(emailController.text);
          Database().getUserByEmail(emailController.text).then((userInfo) {
            HelperFunction.saveUserEmail(emailController.text);
            HelperFunction.saveUserLoggedIn(true);
            HelperFunction.saveUserName(userInfo.documents[0].data['name']);
            Navigator.of(context).pushReplacement(
              new MaterialPageRoute(
                builder: (BuildContext context) => new ChatRooms(),
              ),
            );
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5e5b52),
      appBar: appBar(context),
      body: isloading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textField(
                      "البريد الاكتروني",
                      "example@mail.com",
                      TextInputType.emailAddress,
                      emailController,
                      Icons.email,
                    ),
                    textField(
                      "كلمة المرور",
                      "******",
                      TextInputType.visiblePassword,
                      passwordController,
                      Icons.lock_outline,
                      true,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new ForgotPass(
                                  email: emailController.text,
                                ),
                              ),
                            );
                          },
                          child: simpleTextStyle('نسيت كلمة المرور؟')),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FlatButton(
                        onPressed: signMe,
                        child: buttonsSings(context, "دخول", true)),
                    FlatButton(
                        onPressed: () {},
                        child:
                            buttonsSings(context, "Gmail دخول بحساب", false)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          onPressed: () {
                            widget.toggle();
                          },
                          child: simpleTextStyle('سجل الان', true),
                        ),
                        simpleTextStyle('ليس لديك حساب؟'),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
