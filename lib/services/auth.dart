import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:new_chat/models/userModle.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userID: user.uid) : null;
  }

  Future signinWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser).userID;
    } on PlatformException catch (e) {
      return e.code;
    }
  }

  Future signupWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser).userID;
    } on PlatformException catch (e) {
      return e.code;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
    }
  }
}
