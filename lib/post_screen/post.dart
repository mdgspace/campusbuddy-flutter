import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campusbuddy/notification.dart';
import 'package:campusbuddy/calendar.dart';

class Post extends StatefulWidget {
  final PostDeets postDeets;
  Post(this.postDeets, {Key key}) : super(key: key);
  static const routeName = "/post";
  @override
  _PostState createState() => _PostState(postDeets);
}

class _PostState extends State<Post> {
  static const Color black = const Color(0xff242424);
  static const Color indigo = const Color(0xff303E84);
  PostDeets deets;
  _PostState(this.deets);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            expandedHeight: 210.0,
            backgroundColor: indigo,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                  child: Text(
                    '${deets.group}',
                    style: TextStyle(
                      fontSize:18,
                      fontFamily: 'Roboto',
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                background: Center(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('${deets.imgURL}'),)
                    ),
                  ),
                )
            ),
          ),
          SliverToBoxAdapter(
            child: Material(
              color: Colors.white,
              child: Container(
                height: 1000,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Align(  alignment: Alignment.topLeft,
                                child: Text(deets.title,textAlign: TextAlign.left ,
                                    style: TextStyle(color: indigo,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto')),
                              ),
                            ),flex: 4,
                          ),
                          Expanded(
                            child: IconButton (
                              icon: new SvgPicture.asset('assets/facebookLogo.svg'),
                              iconSize: 40,
                              onPressed: _launchURL,
                            ),flex: 1,
                          ),
                        ],
                      ),
                    ),

                    Padding( padding: const EdgeInsets.all(10.0),
                      child: Text(deets.desc,
                          style: TextStyle(color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Roboto',
                            height: 1.5,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: ScheduleNotification(deets)),
          Container( width:0.4,height: 60,color: Colors.white, ),
          Expanded(child: Calendar(deets)),
        ],) ,
    );


  }
}
_launchURL() async {
  const url = 'https://www.facebook.com/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class PostDeets{
  String title, venue, desc, imgURL, group; DateTime time;
  PostDeets(this.title, this.time, this.venue, this.desc, this.imgURL,
      this.group);
}
