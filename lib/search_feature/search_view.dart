import 'package:campusbuddy/ContactScreens/ContactList.dart';
import 'package:campusbuddy/search_feature/contact_view.dart';
import 'package:flutter/material.dart';
import 'model.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Contact> contactList;

  CustomSearchDelegate({this.contactList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var resultList;
    resultList = contactList.where(
        (contact) => contact.name.toLowerCase().contains(query.toLowerCase()));
    List<Contact> temp = new List<Contact>.from(resultList);

    return ListView.builder(
      itemCount: temp != null ? temp.length : 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ContactView(contact: temp[index],)),);
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${temp[index].name}'),
                  Text('${temp[index].department_name}'),
                ],
              ),
            ),
          ),
        );
      },
    );
    //  return Column();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Column();
  }
}
