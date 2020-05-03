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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                              height: 40,
                              child: Center(
                                  child: Text(postDeets2.group, style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto')))),),

                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(height: 30,
                              child: Align(alignment: Alignment.center,
                                child: Text("Brings to You", style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto')),)),),
                      ])),
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 2,
                  child: Center(
                    child: Text(postDeets2.title, style: TextStyle(
                        color: Colors.indigo[800], fontSize: 30,
                        fontFamily: 'Roboto')),
                  ),
                ),
              ),

              SizedBox(height: 40),

              Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo[900]),
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                        image: NetworkImage('${postDeets2.imgURL}'),
                        fit: BoxFit.fill
                    ),

                  ),),

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
    );
  }

}

