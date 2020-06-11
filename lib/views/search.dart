import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_chat/services/constense.dart';
import 'package:new_chat/services/database.dart';
import 'package:new_chat/views/user_info.dart';
import 'package:new_chat/views/user_info_test.dart';
import 'package:new_chat/widgets/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _search = TextEditingController();
  bool isSearch = false;
  bool textboxSearchHide = true;
  bool hideKeyboardFirsttime = false;
  bool textboxEmpty = true;
  QuerySnapshot searchSnapshot;
  initSearch() {
    if (_search.text != "") {
      setState(() {
        isSearch = true;
      });
    } else {
      setState(() {
        isSearch = false;
      });
    }
    if (!isSearch) {
      Database().getAllUsersa().then((v) {
        setState(() {
          searchSnapshot = v;
        });
      });
    } else {
      Database().getUserByUserName(_search.text).then((v) {
        setState(() {
          searchSnapshot = v;
        });
      });
    }
    if (hideKeyboardFirsttime) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    if (textboxEmpty) {
      textboxSearchHide = true;
    }
    hideKeyboardFirsttime = true;
    setState(() {});
  }

  startConversation(String userEmail, String userName, String userImage,
      DateTime dob, bool isMale) {
    String roomID = getChatRoomID(userEmail, Constanse.myEmail);
    List<String> users = [userName, Constanse.myName];
    List<String> emails = [userEmail, Constanse.myEmail];
    List<String> images = [userImage, Constanse.myImage];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "emails": emails,
      "roomID": roomID,
      "lastMsg": "",
      "time": 0,
      "image": images
    };

    Database().createChatRoom(roomID, chatRoomMap);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoTestScreen(
          userName: userName,
          roomID: roomID,
          userEmail: userEmail,
          userImage: userImage,
          dob: dob,
          isMale: isMale,
          dobAndMale: true,
        ),
      ),
    );
  }

  getChatRoomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget searchList() {
    return searchSnapshot == null
        ? Container()
        : searchSnapshot.documents.length == 0
            ? Center(child: simpleTextStyle("لا يوجد مستخدم بهذا الأسم"))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: searchSnapshot.documents.length,
                itemBuilder: (context, i) {
                  String imageURI = searchSnapshot.documents[i].data['image'];
                  return searchSnapshot.documents[i].data['email'] ==
                          Constanse.myEmail
                      ? Container()
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  startConversation(
                                    searchSnapshot.documents[i].data['email'],
                                    searchSnapshot.documents[i].data['name'],
                                    searchSnapshot.documents[i].data['image'],
                                    searchSnapshot.documents[i].data['DOB']
                                        .toDate(),
                                    searchSnapshot.documents[i].data['isMale'],
                                  );
                                },
                                trailing: Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    color: searchSnapshot
                                            .documents[i].data['logined']
                                        ? Colors.green
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                leading: Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(imageURI),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  searchSnapshot.documents[i].data['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width - 40,
                                color: Colors.black26,
                              )
                            ],
                          ),
                        );
                },
              );
  }

  @override
  void initState() {
    super.initState();
    initSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5e5b52),
      appBar: appBar(context, exit: true, noLogo: true),
      drawer: Drawer(
        child: ListView(
          children: [
            FlatButton(
              onPressed: () {
                setState(() {
                  textboxSearchHide = false;
                  Navigator.pop(context);
                });
              },
              child: Text("بحث"),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          textboxSearchHide
              ? Container()
              : Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.grey[600],
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: Icon(
                              textboxEmpty ? Icons.cancel : Icons.search,
                              size: 30,
                            ),
                            onPressed: initSearch,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _search,
                            onChanged: (value) {
                              setState(() {});
                              if (value.length > 0) {
                                textboxEmpty = false;
                              } else {
                                textboxEmpty = true;
                              }
                            },
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                            decoration: InputDecoration(
                              hintText: "بحث بالأسم",
                              hintStyle: TextStyle(color: Colors.white60),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          Expanded(
            child: searchList(),
          ),
        ],
      ),
    );
  }
}
