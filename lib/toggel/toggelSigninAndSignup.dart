import 'package:flutter/material.dart';
import 'package:new_chat/views/signin.dart';
import 'package:new_chat/views/signup.dart';

class ToggleSigninAndSignup extends StatefulWidget {
  @override
  _ToggleSigninAndSignupState createState() => _ToggleSigninAndSignupState();
}

class _ToggleSigninAndSignupState extends State<ToggleSigninAndSignup> {
  bool isSignin = true;
  void toggle() {
    setState(() {
      isSignin = !isSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isSignin) {
      return Signin(
        toggle: toggle,
      );
    } else {
      return Signup(
        toggle: toggle,
      );
    }
  }
}
