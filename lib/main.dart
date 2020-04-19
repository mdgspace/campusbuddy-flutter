import 'package:flutter/material.dart';
import 'package:campusbuddy/Directory/Directory.dart';
import 'package:campusbuddy/Blank.dart';
void main() => runApp(MyApp());
 /* void main() => runApp(MaterialApp(

    initialRoute: '/',
    routes: {
      '/': (context) => Directory(),

      '/blank': (context) => Blank(),

    }
));
*/
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Directory(),

          '/blank': (context) => Blank(),

        }
    );
  }
}

