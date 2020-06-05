import 'package:cloud_firestore/cloud_firestore.dart';
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

  sendTextChat(String chatRoomID, messageMap) {
    Firestore.instance
        .collection('chat')
        .document(chatRoomID)
        .collection('chatmsg')
        .add(messageMap);
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
}
