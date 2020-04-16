import 'package:campusbuddy/ContactScreens/Contact.dart';
import 'package:campusbuddy/ContactScreens/ContactList.dart';
import 'package:flutter/material.dart';

void main() => runApp(MainScreen());
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainWidget(),
    );
  }
}
class MainWidget extends StatelessWidget {
  Contact instance=new Contact();
  ContactList instance2=new ContactList(title: "Biotechnology",);
  @override
  Widget build(BuildContext context) {
    return instance;

  }
}


