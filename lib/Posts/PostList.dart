import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class PostList extends StatefulWidget {
  static const Color color = const Color(0xff303e84);

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
        title:Text('Feed'),
      centerTitle: true,
      bottom: new TabBar(
          controller: _tabController,
          tabs: <Tab>[
        new Tab(icon: Text('Posts'),),
        new Tab(icon: Text('Events'),),
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
          if (snapshot.hasError) return SliverFillRemaining();
          if (snapshot.data == null ||
              snapshot.data.documents == null ||
              snapshot.data.documents.length == 0)
            return Center(
                heightFactor: 10,
                widthFactor: 10,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              );
          else
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context,int index){
              return getCard(snapshot.data.documents[index]['created_by'], snapshot.data.documents[index]['title'],'',snapshot.data.documents[index]['image']);
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
          if (snapshot.hasError) return SliverFillRemaining();
          if (snapshot.data == null ||
              snapshot.data.documents == null ||
              snapshot.data.documents.length == 0)
            return Center(
              heightFactor: 10,
              widthFactor: 10,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            );
          else
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context,int index){
              return getCard(snapshot.data.documents[index]['created_by'], snapshot.data.documents[index]['title'],'Venue : ${snapshot.data.documents[index]['venue']}',snapshot.data.documents[index]['image']);
            });
        },
      ),
    );
}
Widget getCard(String createdBy,String title,String scheduleAt,String src){
    if(src=="") src="https://lh3.googleusercontent.com/ZDoNo4_cS_KW0B0fKdM3LIkEwfh8LSa6pAnsYKfehdsYlX64DmueZGOTNdXRlo7ccNE";
    return Container(
      child: Card(
        elevation: 10,
        child:Container(
            child: Padding(
            padding: EdgeInsets.fromLTRB(12, 16, 0, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                      child: AspectRatio(
                        aspectRatio: 1/1,
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Image(
                            image: NetworkImage(src,),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text(
                          '$createdBy',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(20),
                            color: Colors.black87
                            )
                        ),

                      ),
                      SizedBox(
                        height: 5.25.h,
                      ),
                      Text(
                          'Title : $title',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(17.52),
                          fontWeight: FontWeight.w500,
                          color: Colors.black87
                        ),
                      ),
                      SizedBox(
                        height: 5.25.h,
                      ),
                      Text(
                          '$scheduleAt',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                  ),
                ],
              ),
            ),
          ),

      ),
      padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
    );
}
}

