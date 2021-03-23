import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'events.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Posts extends StatefulWidget {
  final Deets postDeets;
  Posts(this.postDeets, {Key key}) : super(key: key);
  static const routeName = "/posts";

  @override
  _PostsState createState() => _PostsState(postDeets);
}

class _PostsState extends State<Posts> {
  final Deets postDeets;
  _PostsState(this.postDeets);
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
                  '${postDeets.group}',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              background: (postDeets.imgURL != null && postDeets.imgURL != '')
                  ? Image.network(
                      postDeets.imgURL,
                      fit: BoxFit.cover,
                    )
                  : Container(),
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
                              child: Text(postDeets.title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: indigo,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto')),
                            ),
                            flex: 4,
                          ),
                          Expanded(
                            child: IconButton(
                              icon: new SvgPicture.asset(
                                  'assets/facebookLogo.svg'),
                              iconSize: 40,
                              onPressed: _launchURL,
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Linkify(
                        text: "${postDeets.desc}",
                        style: TextStyle(
                          color: black,
                          fontSize: 19,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto',
                          height: 1.8,
                        ),
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

//For launching FB Url:
_launchURL() async {
  const url = 'https://www.facebook.com/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
