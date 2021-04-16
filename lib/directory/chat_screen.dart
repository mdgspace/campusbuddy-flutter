import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  static const routeName = '/ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  void onSendMessage(String content) async {

    if (content.trim() != '') {
      textEditingController.clear();

      final user = auth.currentUser.email;
      CollectionReference messages =
          FirebaseFirestore.instance.collection('messages');

      await messages
          .add({'content': content, 'by': user, 'time': DateTime.now()});

      _scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send!');
    }
  }

  Widget futureBuilder() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                heightFactor: 10,
                widthFactor: 10,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.indigo[600]),
                ),
              );

            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.indigo[600]),
                ),
              );

            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return new ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot doc = snapshot.data.docs[index];
                      return new ListTile(
                        title: Text(
                          doc["by"],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.grey[500]),
                        ),
                        subtitle: Text(
                          doc["content"],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.indigo[700],
                              fontSize: 18.0),
                        ),
                        trailing: Text(
                          timeago.format(doc["time"].toDate()),
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.grey[500]),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 4.0),
                      );
                    });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        title: Text("Chat"),
      ),
      body: Stack(
        children: <Widget>[
          futureBuilder(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          hintText: "Type your message here..",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        onSendMessage(textEditingController.text);
                      });
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.indigo[700],
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
