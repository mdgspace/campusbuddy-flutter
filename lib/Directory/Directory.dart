import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campusbuddy/Blank.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Directory extends StatefulWidget {
  Directory({Key key}) : super(key: key);

  @override
  _DirectoryState createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 3,

      child: ListTile(
          onTap: (){
            Navigator.pushNamed(context, '/blank' );
          },
        contentPadding: EdgeInsets.all(10),
        leading: SvgPicture.asset(
          'assets/images/icon.svg',
          color: Colors.indigo[800],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.black,
        ),
        title: Text(
          document['group_name'],
          style: TextStyle( fontFamily:'Roboto',),
        ),
      ),
    );
  }

  Widget _buildList(context, snapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return _buildListItem(context, snapshot.data.documents[index]);
        },
        childCount: snapshot.data.documents.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,

      child: Scaffold(
        body: CustomScrollView(

          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.indigo[800],
              title: Text("Telephone Directory"),
              actions: <Widget>[
                IconButton(
                    tooltip: 'Search',
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      //  final int selected = await showSearch<int>();
                    }
                ),
              ],
            ),

            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('groups')
                  .snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // TODO: Better way to represent errors
                if (snapshot.hasError) return SliverFillRemaining();
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  // TODO: Add loading bar
                    return SliverFillRemaining();
                  default:
                    return _buildList(context, snapshot);
                }
              },
            ),

          ],
        ),
        bottomNavigationBar: Material(
          color: Colors.indigo[800],

          child: new TabBar(

            tabs: [
              InkWell(
                  child: Container(
                      width: 100,
                      child: Tab(
                        icon: new Icon(Icons.call),
                        ),
                  ),
              ),
            InkWell(
              child: Container(
                width: 100,
                child: Tab(
                  icon: new Icon(Icons.notifications_active),
                ),
              ),
            ),

            InkWell(
              child: Container(
                width: 100,
                child: Tab(
                  icon: new Icon(Icons.more_horiz),
                ),
              ),
            )
          ],

            indicator: BoxDecoration(
              color: Colors.indigo[900],
            ),
            isScrollable: false,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(5.0),

          ),
        ),
      ),
    );
  }
}
