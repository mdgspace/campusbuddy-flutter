import 'package:flutter/material.dart';
import 'package:campusbuddy/Directory/Directory.dart';

void main() => runApp(MaterialApp(

    initialRoute: '/',
    routes: {
      '/': (context) => Directory(),
      //'/home': (context) => Home(),

    }
));

