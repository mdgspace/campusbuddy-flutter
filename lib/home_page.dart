import 'package:flutter/material.dart';
import 'auth.dart';
import 'root_page.dart';
import 'globals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {

  Auth auth= new Auth();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xFF303E84),
        title: new Text(TELEPHONE_DIRECTORY,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),),
 actions: <Widget>[
   IconButton(
     icon: Icon(
       Icons.exit_to_app,
       color: Colors.white,
     ),
     onPressed: () {
       auth.signOut();
       Navigator.pushAndRemoveUntil(context,
           MaterialPageRoute(builder: (BuildContext context) => RootPage(auth:new Auth())),
           ModalRoute.withName('/'));
     },
   )
 ],
      ),
      body: new Center(
        child: new Text(CAMPUS_BUDDY),
      ),
    );
  }
}