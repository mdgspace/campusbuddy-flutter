import 'package:campusbuddy/screens/department_list.dart';
import 'package:campusbuddy/search_feature/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campusbuddy/auth/root_page.dart';
import 'package:campusbuddy/auth/auth.dart';
import 'package:campusbuddy/search_feature/search_view.dart';
import 'package:http/http.dart' as http;

class DirectoryList extends StatefulWidget {
  @override
  _DirectoryListState createState() => _DirectoryListState();
}

class _DirectoryListState extends State<DirectoryList> {
  Auth auth = new Auth();

  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();
    print('went here');
    loadData();
    print('data loaded');
  }

  void loadData() async {
    var url = Uri.parse('https://raw.githubusercontent.com/mdg-iitr/CampusBuddy/master/app/src/main/assets/contacts.min.json');
    var response = await http.get(url);
    final jsonResponse = groupsFromJson(response.body);
    for (int i = 0; i < jsonResponse.length; i++) {
      List<Department> departmentList = jsonResponse[i].depts;
      for (int j = 0; j < departmentList.length; j++) {
        for (int k = 0; k < departmentList[j].contacts.length; k++) {
          departmentList[j].contacts[k].department_name =
              departmentList[j].deptName;
        }
        contactList = contactList + departmentList[j].contacts;
      }
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 1,
      child: InkWell(
        child: ListTile(
          onTap: () => Navigator.of(context).pushNamed(
            DepartmentListPage.routeName,
            arguments: {
              'group_id': document.id,
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
            style: TextStyle(
              fontFamily: 'Roboto',
            ),
          ),
        ),
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
                }),
            IconButton(
                tooltip: 'search',
                icon: const Icon(Icons.search),
                onPressed: () async {
                  // showConfirmationDialog(context);
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(contactList: contactList),
                  );
                }),
          ],
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('groups').snapshots(),
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
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildListItem(context, snapshot.data.docs[index]);
                    },
                    childCount: snapshot.data.docs.length,
                  ),
                );
            }
          },
        ),
      ],
    );
  }

  void showConfirmationDialog(BuildContext context) {
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
                      TextButton(
                        child: Text(
                          'yes',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onPressed: () {
                          auth.signOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RootPage(auth: new Auth())),
                              ModalRoute.withName('/'));
                        },
                      ),
                      TextButton(
                        child: Text(
                          'no',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
