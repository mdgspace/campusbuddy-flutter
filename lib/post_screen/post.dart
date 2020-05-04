import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:campusbuddy/notification.dart';
import 'package:campusbuddy/calendar.dart';

class Post extends StatefulWidget {
  final PostDeets postDeets;
  Post(this.postDeets, {Key key}) : super(key: key);
  static const routeName = "/post";
  @override
  _PostState createState() => _PostState(postDeets);
}

class _PostState extends State<Post> {

  PostDeets deets;
  _PostState(this.deets);

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
                              height:40,child: Center(child: Text(deets.group ,style: TextStyle(color: Colors.indigo[900],fontSize: 30,fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto')))),),

                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container( height: 30,child: Align( alignment: Alignment.center,
                            child: Text("Brings to You",style: TextStyle(color: Colors.black,fontSize: 20,fontStyle: FontStyle.italic,fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto')),)),),
                      ])),
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 2,
                  child: Center(
                    child: Text(deets.title,style: TextStyle(color: Colors.indigo[800],fontSize: 30,
                        fontFamily: 'Roboto')),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(color: Colors.indigo[700],
                            height: 50,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(child: Text('DATE:' ,
                                      style: TextStyle(color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Roboto'
                                      ))),
                                  SizedBox(height: 3,),
                                  Center(child: Text('${DateFormat("dd-MM-yyyy").format(deets.time)}' ,
                                      style: TextStyle(color: Colors.white,
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Roboto' ))),
                                ])
                        ), flex:1
                    ),

                    Expanded(
                        child: Container(color: Colors.indigo[700],
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(child: Text('TIME:' ,style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Roboto'))),
                                SizedBox(height: 3,),
                                Center(child: Text('${DateFormat.jm().format(deets.time)}' ,style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Roboto'))),
                              ],
                            )
                        ), flex:1
                    ),

                    Expanded(child: Container(color: Colors.indigo[700],
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(child: Text("VENUE: " ,
                                style: TextStyle(color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: 'Roboto'))),
                            SizedBox(height: 3,),
                            Center(child: Text( deets.venue ,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Roboto'))),
                          ],)
                    ),flex: 1,),
                  ]),
              SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo[900]),
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                      image: NetworkImage('${deets.imgURL}'),
                      fit: BoxFit.fill
                  ),
                ),
                child: Image.network('${deets.imgURL}'),
              ),

              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  ScheduleNotification(deets),
                  Calendar(deets),
                ],),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(deets.desc, style: TextStyle(color: Colors.black,fontSize: 15,
                      fontFamily: 'Roboto')
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class PostDeets{
  String title, venue, desc, imgURL, group; DateTime time;
  PostDeets(this.title, this.time, this.venue, this.desc, this.imgURL,
      this.group);
}
