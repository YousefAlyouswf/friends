import 'package:flutter/material.dart';
import 'package:new_chat/services/auth.dart';
import 'package:new_chat/views/signup.dart';
import 'package:new_chat/widgets/widget.dart';

class ForgotPass extends StatefulWidget {
  final String email;

  const ForgotPass({Key key, this.email}) : super(key: key);
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController emailController = TextEditingController();
  bool isloading = false;
  signMe() {
    setState(() {
      isloading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      emailController.text = widget.email;
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
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FlatButton(
                        onPressed: () {
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(emailController.text);
                          if (emailController.text.isEmpty) {
                            print("Empty");
                          } else if (!emailValid) {
                            print("Bad Email");
                          } else {
                            AuthMethod().resetPassword(emailController.text);
                            signMe();
                          }
                        },
                        child: buttonsSings(context, "إرسال", true)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new Signup()));
                            },
                            child: simpleTextStyle('سجل الان', true)),
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
