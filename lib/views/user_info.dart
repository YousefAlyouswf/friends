import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_chat/services/constense.dart';
import 'package:new_chat/services/database.dart';
import 'package:new_chat/services/helperFunctions.dart';
import 'package:new_chat/views/chatRooms.dart';
import 'package:new_chat/widgets/widget.dart';

class UserInfoScreen extends StatefulWidget {
  final String userName;
  final String roomID;
  final String userEmail;
  final String userImage;

  UserInfoScreen({Key key, this.userName, this.roomID, this.userEmail, this.userImage})
      : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool imageSourceVisible = false;
  Future<bool> _onBackPressed() {
    if (widget.roomID == null) {
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRooms(),
        ),
      );
    } else {
      Navigator.pop(context);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double heigh = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xFF5e5b52),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .where('email', isEqualTo: widget.userEmail)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return Container(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment(-0.5,0.2),
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
                    ),
                    Align(
                      alignment: Alignment(0.5,0.2),
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
                    ),
                    Container(
                      height: heigh / 2,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.7), BlendMode.dstATop),
                          image: new NetworkImage(
                            snapshot.data.documents[0].data['image'] == ""
                                ? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-BSzuWpHh8QvPn2YUyA53IMzgM0qWFzRWKis50zcji3Q-WKbN&usqp=CAU"
                                : snapshot.data.documents[0].data['image'],
                          ),
                        ),
                      ),
                    ),
                    widget.roomID == null
                        ? Align(
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
                                        image: new NetworkImage( snapshot.data.documents[0].data['image'] == ""
                                ? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-BSzuWpHh8QvPn2YUyA53IMzgM0qWFzRWKis50zcji3Q-WKbN&usqp=CAU"
                                : snapshot.data.documents[0].data['image'],),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Align(
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
                                    snapshot.data.documents[0].data['image'] ==
                                            ""
                                        ? "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-BSzuWpHh8QvPn2YUyA53IMzgM0qWFzRWKis50zcji3Q-WKbN&usqp=CAU"
                                        : snapshot
                                            .data.documents[0].data['image'],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Align(
                      alignment: Alignment(0, .45),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .2,
                        child: Column(
                          children: [
                            Text(
                              widget.userName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "USA",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Female",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "25",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    widget.roomID == null
                        ? myProfile()
                        : userProfileButtonToChatConversation(context,
                            widget.userName, widget.roomID, widget.userEmail, widget.userImage),
                  ],
                ),
              );
            }),
      ),
    );
  }

  choosrImageSource() {
    setState(() {
      imageSourceVisible = !imageSourceVisible;
    });
  }

  File imageStored;
  String urlImage;

  final picker = ImagePicker();
  _takeFromGalary() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 100, maxWidth: 1200);
    setState(() {
      imageStored = File(pickedFile.path);
    });
    uploadImage();
    imageSourceVisible = false;
  }

  _takePicture() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, imageQuality: 100, maxWidth: 1200);
    setState(() {
      imageStored = File(pickedFile.path);
    });
    uploadImage();
    imageSourceVisible = false;
  }

  Future uploadImage() async {
    String fileName = '${DateTime.now()}.png';

    StorageReference firebaseStorage =
        FirebaseStorage.instance.ref().child(fileName);

    StorageUploadTask uploadTask = firebaseStorage.putFile(imageStored);
    await uploadTask.onComplete;
    urlImage = await firebaseStorage.getDownloadURL() as String;

    if (urlImage.isNotEmpty) {
      Database().getUserID(Constanse.myEmail).then((v) {
        v.documents.forEach((result) async {
          Firestore.instance
              .collection('users')
              .document(result.documentID)
              .updateData({
            "image": urlImage,
          });

          HelperFunction.saveUserImage(urlImage);
          Constanse.myImage = await HelperFunction.getUserImage();
          setState(() {});
        });
      });
    }
  }
}
