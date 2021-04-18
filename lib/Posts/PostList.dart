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
  Counting _counting = new Counting();
  int totPost = 0, totEvent = 0;
  bool postSelect = false, eventSelect = false;
  String dropdownValue = "None";
  TabController _tabController;
  List<String> items = [];
  String filter = '';
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(410, 703),
      allowFontScaling: true,
      builder: () => Scaffold(
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
                height: 1,
                color: Colors.black,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue ?? 'None';
                });
              },
              items: <String>[
                'None',
                'Mobile development group',
                'Information Management Group',
                'Vision and Language Group',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value ?? '',
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
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
    _counting.beReady().then((value) {
      setState(() {});
    });
    _saveDeviceToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message.notification.title),
              subtitle: Text(message.notification.body),
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
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // TODO optional
    });
  }

  _saveDeviceToken() async {
    // Get the current userID

    final User user = auth.currentUser;
    final uid = user.uid;

    // Then get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save the userID(if not previously saved) and their device token to Firestore
    if (fcmToken != null) {
      var tokens =
          _db.collection('users').doc(uid).collection('tokens').doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
      });
    }
  }

  Widget posts() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('');
          if (snapshot.data == null ||
              snapshot.data.docs == null ||
              snapshot.data.docs.length == 0)
            return Center(
              heightFactor: 10,
              widthFactor: 10,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.indigo[600]),
              ),
            );
          else {
            totPost = snapshot.data.docs.length ?? 0;
            var bet = PostList.totReadPost ?? 0;
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  if (totPost > bet && bet != 0) {
                    postSelect = true;
                    bet++;
                  } else {
                    postSelect = false;
                  }
                  DateTime postedAt =
                      (snapshot.data.docs[index]['created_at']).toDate();
                  Deets postDeets = new Deets(
                      snapshot.data.docs[index]['title'],
                      null,
                      null,
                      snapshot.data.docs[index]['description'],
                      snapshot.data.docs[index]['image'],
                      snapshot.data.docs[index]['created_by'],
                      snapshot.data.docs[index]['latitude'],
                      snapshot.data.docs[index]['longitude']);
                  return dropdownValue == "None"
                      ? getCard(postDeets, postedAt, postSelect, index)
                      : (dropdownValue == postDeets.group)
                          ? getCard(postDeets, postedAt, postSelect, index)
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
        stream: FirebaseFirestore.instance
            .collection('Events')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('');
          if (snapshot.data == null ||
              snapshot.data.docs == null ||
              snapshot.data.docs.length == 0)
            return Center(
              heightFactor: 10,
              widthFactor: 10,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.indigo[600]),
              ),
            );
          else {
            totEvent = snapshot.data.docs.length ?? 0;
            var bets = PostList.totReadEvent ?? 0;
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime timestamp =
                      (snapshot.data.docs[index]['scheduled_at']).toDate();
                  DateTime postedAt =
                      (snapshot.data.docs[index]['created_at']).toDate();
                  Deets postDeets = new Deets(
                      snapshot.data.docs[index]['title'],
                      timestamp,
                      snapshot.data.docs[index]['venue'],
                      snapshot.data.docs[index]['description'],
                      snapshot.data.docs[index]['image'],
                      snapshot.data.docs[index]['created_by'],
                      snapshot.data.docs[index]['longitude'],
                      snapshot.data.docs[index]['latitude']);

                  if (totEvent > bets && bets != 0) {
                    eventSelect = true;
                    bets++;
                  } else {
                    eventSelect = false;
                  }
                  return dropdownValue == "None"
                      ? getCard(postDeets, postedAt, eventSelect, index)
                      : (dropdownValue == postDeets.group)
                          ? getCard(postDeets, postedAt, eventSelect, index)
                          : new Container();
                });
          }
        },
      ),
    );
  }

  Widget getCard(Deets postDeets, DateTime postedAt, bool selected, int index) {
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
          if ((index ?? 0) < ((totPost ?? 0) - (PostList.totReadPost ?? 0))) {
            _counting.totPostEventCount(((totPost ?? 0) - (index ?? 0)), 1);
          }
          Navigator.of(context)
              .pushNamed(Posts.routeName, arguments: postDeets);
        } else {
          if ((index) < ((totEvent ?? 0) - (PostList.totReadEvent ?? 0))) {
            _counting.totPostEventCount(((totEvent ?? 0) - (index ?? 0)), 2);
          }

          Navigator.of(context)
              .pushNamed(Events.routeName, arguments: postDeets);
        }
      },
      child: Container(
        child: Card(
          color: selected ? Color(0xFFf0f3f4) : Colors.white,
          elevation: 3,
          shape: new RoundedRectangleBorder(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                      child: selected
                          ? Icon(
                              Icons.markunread,
                              color: Colors.blue,
                            )
                          : Icon(Icons.done, color: Colors.blue),
                    ),
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
}

class Counting {
  Auth auth = new Auth();
  var document;
  User user;
  var uid;
  Future beReady() async {
    User user = auth.getCurrentUser();
    uid = user.uid;
    document = await FirebaseFirestore.instance.collection('users').doc(uid);
    await document.get().then((value) {
      PostList.totReadEvent = value.data()["readEvent"];
      PostList.totReadPost = value.data()["readPost"];
    });
  }

  Future totPostEventCount(int x, int update) async {
    if (update == 1) {
      document.update({'readPost': x});
    } else if (update == 2) {
      document.update({'readEvent': x});
    }
    beReady();
  }
}
