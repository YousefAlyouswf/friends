import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_chat/services/constense.dart';
import 'package:new_chat/services/database.dart';
import 'package:new_chat/views/converstionScreen.dart';
import 'package:new_chat/widgets/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _search = TextEditingController();
  bool isSearch = false;
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
  }

  startConversation(String userName) {
    String roomID = getChatRoomID(userName, Constanse.myName);
    List<String> users = [userName, Constanse.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "roomID": roomID,
    };

    Database().createChatRoom(roomID, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(
                  userName: userName,
                )));
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
                  return searchSnapshot.documents[i].data['email'] ==
                          Constanse.myEmail
                      ? Container()
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            onTap: () {
                              startConversation(
                                searchSnapshot.documents[i].data['name'],
                              );
                            },
                            trailing: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color:
                                    searchSnapshot.documents[i].data['logined']
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
                                  image: new AssetImage(
                                      "assets/images/chat.png"),
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
      appBar: appBar(context),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Container(
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
                              Icons.search,
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
