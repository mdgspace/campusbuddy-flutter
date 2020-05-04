import 'package:flutter/material.dart';
import 'post.dart';


class Post2 extends StatefulWidget
{
  final PostDeets postDeets2;
  Post2(this.postDeets2, {Key key}) : super(key: key);
  static const routeName = "/post2";

  @override
  _Post2State createState() => _Post2State(postDeets2);
}

class _Post2State extends State<Post2> {
  final PostDeets postDeets2;
  _Post2State(this.postDeets2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,30.0,0.0,0.0),
                  child: Container(
                      width: double.infinity,
                      child: Align(  alignment: Alignment.center,
                        child: Text(postDeets2.group ,style: TextStyle(color: Colors.indigo[900],fontSize: 30,fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto')),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,10.0, 0, 0),
                  child: Container(
                      width: double.infinity,
                      child: Align( alignment: Alignment.center,
                        child: Text("Brings to You",style: TextStyle(color: Colors.black,fontSize: 20,fontStyle: FontStyle.italic,fontWeight: FontWeight.w700,
                            fontFamily: 'Roboto')),)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container(
                    width: double.infinity,
                    child: Align(  alignment: Alignment.center,
                      child: Text(postDeets2.title,style: TextStyle(color: Colors.indigo[800],fontSize: 30,fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto')),
                    ),
                  ),
                ),


                SizedBox(height: 40),

                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.indigo[900]),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Image.network('${postDeets2.imgURL}')

                ),

                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(postDeets2.desc,
                        style: TextStyle(color: Colors.black, fontSize: 15,
                            fontFamily: 'Roboto')
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

}

