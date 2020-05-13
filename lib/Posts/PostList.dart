import 'package:campusbuddy/ContactScreens/ContactList.dart';
import 'package:campusbuddy/post_screen/post.dart';
import 'package:campusbuddy/post_screen/post2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostList extends StatefulWidget {
  static const Color color = const Color(0xff303e84);
 static final svgArrowIcon=ContactList.svgArrowIcon;
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList>  with SingleTickerProviderStateMixin{
  TabController _tabController;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true, width: 410, height: 703);
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: PostList.color,
        elevation: 0,
        title:Text('Campus Updates'),
      bottom: new TabBar(
       indicatorColor: Colors.white,
          controller: _tabController,
          tabs: <Tab>[
        new Tab(icon: Text('Posts',
          style: TextStyle(
              fontSize: 20.sp
          ),),),
        new Tab(icon: Text('Events',
        style: TextStyle(
          fontSize: 20.sp
        ),
        ),),
      ]),
      ),
      body: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            posts(),
            events()
      ]),
    );
  }

  TabController getTabController() {
    return TabController(length: 2,vsync:this);
  }

  @override
  void initState() {
    super.initState();
    _tabController = getTabController();
  }

  Widget posts(){
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Posts').orderBy('created_at',descending: true)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          else
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context,int index){
                  DateTime postedAt=(snapshot.data.documents[index]['created_at']).toDate();
                  PostDeets postDeets=new PostDeets(snapshot.data.documents[index]['title'], null,null, snapshot.data.documents[index]['description'], snapshot.data.documents[index]['image'], snapshot.data.documents[index]['created_by']);
                  return getCard(postDeets,postedAt);
            });
        },
      ),
    );
}

Widget events(){
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Events').orderBy('created_at',descending: true)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          else
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context,int index){
                  DateTime timestamp=(snapshot.data.documents[index]['scheduled_at']).toDate();
                  DateTime postedAt=(snapshot.data.documents[index]['created_at']).toDate();
                  PostDeets postDeets=new PostDeets(snapshot.data.documents[index]['title'], timestamp, snapshot.data.documents[index]['venue'], snapshot.data.documents[index]['description'], snapshot.data.documents[index]['image'], snapshot.data.documents[index]['created_by']);
              return getCard(postDeets,postedAt);
            });
        },
      ),
    );
}
Widget getCard(PostDeets postDeets,DateTime postedAt){
  String createdBy="",title="", scheduleAt="", src="";
  String timePast= timeago.format(postedAt);
  print(timeago.format(postedAt));
  createdBy=postDeets.group;title=postDeets.title;
  if(postDeets.venue!=null){
  scheduleAt=postDeets.venue;}
  src=postDeets.imgURL;
    if(src==null || src=="") src="https://lh3.googleusercontent.com/ZDoNo4_cS_KW0B0fKdM3LIkEwfh8LSa6pAnsYKfehdsYlX64DmueZGOTNdXRlo7ccNE";
    return GestureDetector(
      onTap: (){
      if(postDeets.venue==null){
        Navigator.of(context).pushNamed(Post2.routeName,arguments: postDeets);
      }
      else{
        Navigator.of(context).pushNamed(Post.routeName,arguments: postDeets);
      }
      },
      child: Container(
        child: Card(
          elevation: 3,
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
                                image:new DecorationImage(image: NetworkImage(src,),
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
                                          fontFamily:'Roboto',
                                          fontSize: ScreenUtil().setSp(12),
                                        color: Color(0xFF3B3B3B)
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    height: 5.25.h,
                                  ),
                                  Text(
                                      '$title',
                                    style: TextStyle(
                                        fontFamily:'Roboto',
                                        fontSize: ScreenUtil().setSp(17.52),
                                      color: Colors.black87
                                    ),
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
                            child: Text('$timePast' ,
                              style: TextStyle(
                                fontFamily:'Roboto',
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
}

