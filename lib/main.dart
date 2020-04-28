import 'package:campusbuddy/ContactScreens/Contact.dart';
import 'package:campusbuddy/ContactScreens/ContactList.dart';
import 'package:flutter/material.dart';

void main() => runApp(MainScreen());
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute:  '/ContactList',
      routes:{
        '/Contact':(context)=>Contact(),
        '/ContactList' : (context) => ContactList(),
      },
    );
  }
}
class MainWidget extends StatelessWidget {
  Contact instance=new Contact();
  ContactList instance2=new ContactList();
  @override
  Widget build(BuildContext context) {
    return instance2;

  }
}
