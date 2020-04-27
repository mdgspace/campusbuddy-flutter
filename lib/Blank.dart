import 'main.dart';
import 'package:flutter/material.dart';

class Blank extends StatefulWidget {
  @override
  _BlankState createState() => _BlankState();
}

class _BlankState extends State<Blank> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigoAccent[400],

      child: Center(
        child: Text("Site Under Construction;)",style: TextStyle(
          fontSize: 20,color: Colors.black
        ),
        ),
      ),


    );
  }
}
