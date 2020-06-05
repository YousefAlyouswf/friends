import 'package:cloud_firestore/cloud_firestore.dart';

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
        .collection('users').orderBy("logined", descending: true)
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
}
