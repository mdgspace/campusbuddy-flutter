import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentListPage extends StatelessWidget {
  static const routeName = '/departments';

  // Name of the group
  final groupName;
  // Doc ID of current group
  final groupDocID;

  DepartmentListPage(
      {Key key, @required this.groupName, @required this.groupDocID})
      : super(key: key);

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ListTile(
        onTap: () => Navigator.of(context).pushNamed("/contactList", arguments: {
          'dept_name': document['dept_name'],
          'dept_id': 'groups/$groupDocID/departments/${document.id}',
        }),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                groupName,
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
            stream: FirebaseFirestore.instance
                .collection('groups/$groupDocID/departments')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return SliverFillRemaining();
              if (snapshot.data == null ||
                  snapshot.data.docs == null ||
                  snapshot.data.docs.length == 0)
                return SliverToBoxAdapter(
                  child: Center(
                    heightFactor: 10,
                    widthFactor: 10,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.indigo[600]),
                    ),
                  ),
                );
              else
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return _buildListItem(context, snapshot.data.docs[index]);
                    },
                    childCount: snapshot.data.docs.length,
                  ),
                );
            },
          )
        ],
      ),
    );
  }
}
