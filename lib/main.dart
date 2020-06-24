import 'package:campusbuddy/auth/auth.dart';
import 'package:campusbuddy/auth/root_page.dart';
import 'package:campusbuddy/generate_route.dart';
import 'package:flutter/material.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Buddy',
      theme: ThemeData(primaryColor: Color(0xff303E84)),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
    );
  }
}

