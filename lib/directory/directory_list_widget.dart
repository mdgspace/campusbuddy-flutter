
import 'package:campusbuddy/screens/department_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campusbuddy/auth/root_page.dart';
import 'package:campusbuddy/auth/auth.dart';

class DirectoryList extends StatelessWidget {
  Auth auth= new Auth();

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
                tooltip: 'log out',
                icon: const Icon(Icons.power_settings_new),
                onPressed: () async {
                  //  final int selected = await showSearch<int>();
                  showConfirmationDialog(context);

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

  void showConfirmationDialog(BuildContext context)
  {
    showDialog(
      context: context,
        builder: (BuildContext context) {
      return Dialog(
        child: Container(
          height: 100,
          width: 100,
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Text('Are you sure want to log out?'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                     child: Text('yes',
                     style: TextStyle(
                       color: Colors.grey,
                     ),),
                    onPressed: ()
                    {
                      auth.signOut();
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) => RootPage(auth:new Auth())),
                          ModalRoute.withName('/'));
                    },
                  ),
                  FlatButton(
                    child: Text('no',
                      style: TextStyle(
                        color: Colors.blue
                    ),),
                    onPressed: ()
                    {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      );
          }
    );
  }
}
