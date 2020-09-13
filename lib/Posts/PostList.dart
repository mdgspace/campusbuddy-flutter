import 'package:campusbuddy/ContactScreens/ContactList.dart';
import 'package:campusbuddy/post_screen/events.dart';
import 'package:campusbuddy/post_screen/posts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:campusbuddy/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PostList extends StatefulWidget {
  static const Color color = const Color(0xff303e84);
  static final svgArrowIcon = ContactList.svgArrowIcon;
  static int totReadPost = 0, totReadEvent = 0;
  @override
  _PostListState createState() => _PostListState();
}


class _PostListState extends State<PostList>
    with SingleTickerProviderStateMixin {
  int totPost = 0, totEvent = 0;
  bool postSelect = false, eventSelect = false;
  String dropdownValue = "None";
  TabController _tabController;
  List<String> items;
  String filter;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true, width: 410, height: 703);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PostList.color,
        elevation: 0,
        title: Text('Campus Updates'),
        bottom: new TabBar(
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: <Tab>[
              new Tab(
                icon: Text(
                  'Posts',
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
              new Tab(
                icon: Text(
                  'Events',
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
            ]),
      ),
      body: Column(
        children: <Widget>[
          DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.filter_list),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>[
              'None',
              'Mobile development group',
              'Information Management Group',
              'Vision and Language Group'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Flexible(
            child: new TabBarView(
                controller: _tabController,
                children: <Widget>[posts(), events()]),
          ),
        ],
      ),
    );
  }

  TabController getTabController() {
    return TabController(length: 2, vsync: this);
  }

  @override
  void initState() {
    super.initState();
    _tabController = getTabController();

    totPostEventCount(totPost, 0).then((value) {
      setState(() {
      });
    });
        _saveDeviceToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[

              FlatButton(
                color: Colors.indigo,
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

    _saveDeviceToken() async {
    // Get the current userID

    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    print(uid);

    // Then get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save the userID(if not previously saved) and their device token to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);
      print(fcmToken);

      await tokens.setData({
        'token': fcmToken,
      });
    }
  }


  Widget posts() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Posts')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('');
          if (snapshot.data == null ||
              snapshot.data.documents == null ||
              snapshot.data.documents.length == 0)
            return Center(
              heightFactor: 10,
              widthFactor: 10,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.indigo[600]),
              ),
            );
          else {
            totPost = snapshot.data.documents.length;
            totPostEventCount(totPost, 1);
            return ListView.builder(
                itemCount: snapshot.data.documents.length,

                itemBuilder: (BuildContext context, int index) {
                  if (totPost != PostList.totReadPost) {
                    postSelect = true;
                    PostList.totReadPost++;
                  } else {
                    postSelect = false;
                  }
                  DateTime postedAt =
                      (snapshot.data.documents[index]['created_at']).toDate();
                  Deets postDeets = new Deets(
                      snapshot.data.documents[index]['title'],
                      null,
                      null,
                      snapshot.data.documents[index]['description'],
                      snapshot.data.documents[index]['image'],
                      snapshot.data.documents[index]['created_by']);
                  return dropdownValue == "None"
                      ? getCard(postDeets, postedAt, postSelect)
                      : (dropdownValue == postDeets.group)
                          ? getCard(postDeets, postedAt, postSelect)
                          : new Container();
                });
          }
        },
      ),
    );
  }

  Widget events() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Events')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('');
          if (snapshot.data == null ||
              snapshot.data.documents == null ||
              snapshot.data.documents.length == 0)
            return Center(
              heightFactor: 10,
              widthFactor: 10,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.indigo[600]),
              ),
            );
          else {
            totEvent = snapshot.data.documents.length;
            totPostEventCount(totEvent, 2);
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime timestamp =
                      (snapshot.data.documents[index]['scheduled_at']).toDate();
                  DateTime postedAt =
                      (snapshot.data.documents[index]['created_at']).toDate();
                  Deets postDeets = new Deets(
                      snapshot.data.documents[index]['title'],
                      timestamp,
                      snapshot.data.documents[index]['venue'],
                      snapshot.data.documents[index]['description'],
                      snapshot.data.documents[index]['image'],
                      snapshot.data.documents[index]['created_by']);
                  if (totEvent != PostList.totReadEvent) {
                    eventSelect = true;
                    PostList.totReadEvent++;
                  } else {
                    eventSelect = false;
                  }
                  return dropdownValue == "None"
                      ? getCard(postDeets, postedAt, eventSelect)
                      : (dropdownValue == postDeets.group)
                          ? getCard(postDeets, postedAt, eventSelect)
                          : new Container();
                });
          }
        },
      ),
    );
  }

  Widget getCard(Deets postDeets, DateTime postedAt, bool selected) {
    String createdBy = "", title = "", scheduleAt = "", src = "";
    String timePast = timeago.format(postedAt);
    createdBy = postDeets.group;
    title = postDeets.title;
    if (postDeets.venue != null) {
      scheduleAt = postDeets.venue;
    }
    src = postDeets.imgURL;
    if (src == null || src == "")
      src =
          "https://lh3.googleusercontent.com/ZDoNo4_cS_KW0B0fKdM3LIkEwfh8LSa6pAnsYKfehdsYlX64DmueZGOTNdXRlo7ccNE";
    return GestureDetector(
      onTap: () {
        if (postDeets.venue == null) {
          Navigator.of(context)
              .pushNamed(Posts.routeName, arguments: postDeets);
        } else {
          Navigator.of(context).pushNamed(Events.routeName, arguments: postDeets);
        }
      },
      child: Container(
        child: Card(
          elevation: 3,
          shape: selected
              ? new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(4.0))
              : new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(4.0)),
          child: Container(
            padding: EdgeInsets.fromLTRB(11, 18, 17, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 42.h,
                        width: 42.w,
                        padding: EdgeInsets.all(11.sp),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            image: NetworkImage(
                              src,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 17.0.w,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$createdBy',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Color(0xFF3B3B3B)),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 5.25.h,
                            ),
                            Text(
                              '$title',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: ScreenUtil().setSp(17.52),
                                  color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ContactList.svgArrowIcon,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 12, 0, 0),
                      child: Text(
                        '$timePast',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: ScreenUtil().setSp(12),
                          color: Color(0xFF3B3B3B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        padding: EdgeInsets.fromLTRB(14, 8, 14, 0),
      ),
    );
  }

  Future totPostEventCount(int x, int update) async {
    Auth auth = new Auth();
    final FirebaseUser user = await auth.getCurrentUser();
    final uid = user.uid;
    // here you write the codes to input the data into firestore
    var document = await Firestore.instance.collection('users').document(uid);
    document.get().then((value) {
      PostList.totReadEvent = value.data["readEvent"];
      PostList.totReadPost = value.data["readPost"];
    });
    if (update == 1) {
      document.updateData({"readPost": x});
    } else if (update == 2) {
      document.updateData({"readEvent": x});
    }
  }
}
