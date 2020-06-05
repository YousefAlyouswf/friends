import 'package:flutter/material.dart';
import 'package:new_chat/services/auth.dart';
import 'package:new_chat/services/database.dart';
import 'package:new_chat/services/helperFunctions.dart';
import 'package:new_chat/views/chatRooms.dart';
import 'package:new_chat/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgotpassword.dart';

class Signup extends StatefulWidget {
  final Function toggle;

  const Signup({Key key, this.toggle}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthMethod _authMethod = new AuthMethod();
  bool isloading = false;
  signMe() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      fluttertoastWarning("يجب ملئ جميع الحقول");
    } else {
      _authMethod
          .signupWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) async {
        if (value == "ERROR_EMAIL_ALREADY_IN_USE") {
          fluttertoastWarning(
              "الإيميل مستخدم من قبل يمكنك أستعاده حسابك بالضغط على (نسيت كلمة المرور)",
              true);
          forgetPass();
        } else if (value == "ERROR_INVALID_EMAIL") {
          fluttertoastWarning("خطأ في كتابة الإيميل");
        } else if (value == "ERROR_WEAK_PASSWORD") {
          fluttertoastWarning("كلمة المرور ضعيفة");
        } else {
          Database().updateLoginedToTrue(emailController.text);
          HelperFunction.saveUserEmail(emailController.text);
          HelperFunction.saveUserLoggedIn(true);
          HelperFunction.saveUserName(nameController.text);
          setState(() {
            isloading = true;
          });
          Map<String, dynamic> userMap = {
            'name': nameController.text,
            'email': emailController.text,
            'password': passwordController.text,
          };

          Database().uploadUserInfo(userMap);
          Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
              builder: (BuildContext context) => new ChatRooms(),
            ),
          );
        }
      });
    }
  }

  bool visible = false;
  void forgetPass() {
    setState(() {
      visible = true;
    });
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
                      "أسمك",
                      "يوسف",
                      TextInputType.text,
                      nameController,
                      Icons.person,
                    ),
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
                    Visibility(
                      visible: visible,
                      child: Container(
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
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FlatButton(
                      child: buttonsSings(context, "تسجيل", true),
                      onPressed: signMe,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          onPressed: widget.toggle,
                          child: simpleTextStyle('دخول', true),
                        ),
                        simpleTextStyle('لديك حساب!!'),
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
