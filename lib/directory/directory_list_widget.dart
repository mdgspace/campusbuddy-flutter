import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DirectoryList extends StatelessWidget {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 1,

      child: InkWell(
        child: ListTile(
          onTap: () => Navigator.of(context).pushNamed(
            DepartmentListPage.routeName,
            arguments: {
              'group_id': document.documentID,
              'group_name': document['group_name']
            },
          ),
          contentPadding: EdgeInsets.all(10),
          leading: SvgPicture.asset(
            'assets/icon.svg',
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
    return CustomScrollView(
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
                return SliverToBoxAdapter(
                  child: Center(
                    heightFactor: 20,
                    widthFactor: 10,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.indigo[600]),
                    ),
                  ),
                );
              default:
                return _buildList(context, snapshot);
            }
          },
        ),
      ],
    );
  }
}
