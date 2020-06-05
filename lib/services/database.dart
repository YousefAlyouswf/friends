import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_chat/services/constense.dart';

class Database {
  getUserByUserName(String userName) async {
    return await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: userName)
        .getDocuments()
        .catchError((e) {
      print(e);
    });
  }

  getUserByEmail(String userEmail) async {
    return await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .getDocuments()
        .catchError((e) {
      print(e);
    });
  }

  getAllUsersa() async {
    return await Firestore.instance
        .collection('users')
        .orderBy("logined", descending: true)
        .getDocuments()
        .catchError((e) {
      print(e);
    });
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection('users').add(userMap).catchError((e) {
      print(e);
    });
  }

  updateLoginedToFlase(String email) async {
    await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments()
        .then((event) {
      event.documents.forEach((result) {
        Firestore.instance
            .collection('users')
            .document(result.documentID)
            .updateData({
          "logined": false,
        });
      });
    }).catchError((e) => print("error fetching data: $e"));
  }

  updateLoginedToTrue(String email) async {
    await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments()
        .then((event) {
      event.documents.forEach((result) {
        Firestore.instance
            .collection('users')
            .document(result.documentID)
            .updateData({
          "logined": true,
        });
      });
    }).catchError((e) => print("error fetching data: $e"));
  }

  createChatRoom(String chatRoomId, chatRoomMap) async {
    final snapShot =
        await Firestore.instance.collection('chat').document(chatRoomId).get();

    if (snapShot == null || !snapShot.exists) {
      Firestore.instance
          .collection('chat')
          .document(chatRoomId)
          .setData(chatRoomMap)
          .catchError((e) {
        print(e);
      });
    }
  }

  sendTextChat(String chatRoomID, messageMap, String userEmail, String text,
      int time, BuildContext context) async {
    bool blockedMe = false;
    await Firestore.instance
        .collection('users')
        .where("email", isEqualTo: userEmail)
        .getDocuments()
        .then((v) {
      v.documents.forEach((result) async {
        for (var i = 0; i < result['blockList'].length; i++) {
          String email = result['blockList'][i];
          if (email == Constanse.myEmail) {
            blockedMe = true;
          }
        }
        if (blockedMe) {
          
        } else {
          await Firestore.instance
              .collection('chat')
              .document(chatRoomID)
              .collection('chatmsg')
              .add(messageMap);
          setLastMsg(chatRoomID, text, time);
        }
      });
    });
  }

  setLastMsg(String chatID, String lastMsg, int time) {
    Firestore.instance
        .collection('chat')
        .document(chatID)
        .updateData({"lastMsg": lastMsg, "time": time});
  }

  getTextChat(String chatRoomID) {
    return Firestore.instance
        .collection('chat')
        .document(chatRoomID)
        .collection('chatmsg')
        .getDocuments();
  }

  getChatRooms(String userName) {
    return Firestore.instance
        .collection('chat')
        .where("users", arrayContains: Constanse.myName)
        .snapshots();
  }

  addToBlockList(String userEmail, String userID) {
    Firestore.instance.collection('users').document(userID).updateData({
      "blockList": FieldValue.arrayUnion([userEmail])
    });
  }

  getUserID(String userEmail) async {
    return await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: Constanse.myEmail)
        .getDocuments();
  }
}
