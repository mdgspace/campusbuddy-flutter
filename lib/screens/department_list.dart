import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentListPage extends StatelessWidget {
  // Name of the group
  final title;
  // Doc ID of current group
  final groupDocID;

  DepartmentListPage({Key key, this.title, this.groupDocID}) : super(key: key);

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: SvgPicture.asset(
          'assets/department_icon.svg',
          color: Theme.of(context).primaryColor,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Color(0XFF3B3B3B),
        ),
        title: Text(
          document['dept_name'],
          style: TextStyle(
            fontSize: 17,
          ),
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
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 28,
                ),
              ),
              background: Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 70),
                child: SvgPicture.asset(
                  'assets/department_icon.svg',
                  color: Colors.white,
                ),
              ),
            ),
            expandedHeight: 250,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('groups/$groupDocID/departments')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // TODO: Better way to represent errors
              if (snapshot.hasError) return SliverFillRemaining();
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return SliverToBoxAdapter(
                    child: Center(
                      heightFactor: 10,
                      widthFactor: 10,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                      ),
                    ),
                  );
                default:
                  return _buildList(context, snapshot);
              }
            },
          )
        ],
      ),
    );
  }
}
