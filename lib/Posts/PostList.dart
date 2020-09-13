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
import 'package:campusbuddy/auth/auth.dart';

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
              height: 1,
              color: Colors.black,
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
              'Vision and Language Group',

            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
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
    );
  }

  TabController getTabController() {
    return TabController(length: 2, vsync: this);
  }

  @override
  void initState() {
    super.initState();
    _tabController = getTabController();
    _counting.beReady().then((value)
    {
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
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        // TODO optional
      },
    );
  }

    _saveDeviceToken() async {
    // Get the current userID

    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;

    // Then get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save the userID(if not previously saved) and their device token to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

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
            var bet=PostList.totReadPost;
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  if (totPost > bet && bet!=0){
                    postSelect = true;
                    bet++;
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
                      ? getCard(postDeets, postedAt, postSelect,index)
                      : (dropdownValue == postDeets.group)
                          ? getCard(postDeets, postedAt, postSelect,index)
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
            var bets=PostList.totReadEvent;
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

                  if (totEvent > bets && bets!=0) {
                    eventSelect = true;
                    bets++;
                  } else {
                    eventSelect = false;
                  }
                  return dropdownValue == "None"
                      ? getCard(postDeets, postedAt, eventSelect,index)
                      : (dropdownValue == postDeets.group)
                          ? getCard(postDeets, postedAt, eventSelect,index)
                          : new Container();
                });
          }
        },
      ),
    );
  }

  Widget getCard(Deets postDeets, DateTime postedAt, bool selected,int index) {

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
          if((index)<(totPost-PostList.totReadPost)){
          _counting.totPostEventCount((totPost-index), 1);
          }
          Navigator.of(context)
              .pushNamed(Posts.routeName, arguments: postDeets);
        } else {
          if((index)<(totEvent-PostList.totReadEvent)){
          _counting.totPostEventCount((totEvent-index), 2);
          }

          Navigator.of(context).pushNamed(Events.routeName, arguments: postDeets);
        }
      },
      child: Container(
        child: Card(
          color: selected?Color(0xFFf0f3f4):Colors.white,
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
                      child: selected?Icon(Icons.markunread,color: Colors.blue,):Icon(Icons.done,color:Colors.blue),
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
class Counting{
  Auth auth = new Auth();
  var document;
  FirebaseUser user;
  var uid;
  Future beReady() async{
    FirebaseUser user = await auth.getCurrentUser();
    uid = user.uid;
    document = await Firestore.instance.collection('users').document(uid);
    await document.get().then((value) {
      PostList.totReadEvent = value.data["readEvent"];
      PostList.totReadPost = value.data["readPost"];

    });
  }
  Future totPostEventCount(int x, int update) async {
    if (update == 1) {
    document.updateData({"readPost": x});
  } else if (update == 2) {
    document.updateData({"readEvent": x});
  }
    beReady();
  }
}