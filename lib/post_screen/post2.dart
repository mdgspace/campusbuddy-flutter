import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'post.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Post2 extends StatefulWidget
{
  final PostDeets postDeets2;
  Post2(this.postDeets2, {Key key}) : super(key: key);
  static const routeName = "/post2";

  @override
  _Post2State createState() => _Post2State(postDeets2);
}

class _Post2State extends State<Post2> {

  final PostDeets postDeets2;
  _Post2State(this.postDeets2);
  static const Color black = const Color(0xff242424);
  static const Color indigo = const Color(0xff303E84);

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
                    '${postDeets2.group}',
                    style: TextStyle(
                      fontSize:18,
                      fontFamily: 'Roboto',
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                background: Image.network('${postDeets2.imgURL}',fit: BoxFit.cover,)
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
                      padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                  postDeets2.title,
                                  textAlign: TextAlign.left ,
                                  style: TextStyle(color: indigo,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto')),
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
                      child: Linkify(
                        text: "${postDeets2.desc}",
                        style: TextStyle(color: black,
                          fontSize: 19,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto',
                          height: 1.8,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

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
