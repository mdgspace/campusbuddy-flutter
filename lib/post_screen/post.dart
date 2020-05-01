import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
PostDeets deets;
  Widget _buildPost( BuildContext context, DocumentSnapshot documents) {
     deets = new PostDeets(documents['title'].toString(), documents['scheduled_at'].toDate(), documents['venue'].toString(),
        documents['description'].toString(), documents['image'].toString(), documents['created_by'].toString());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            height:40,child: Center(child: Text(deets.group ,style: TextStyle(color: Colors.indigo[900],fontSize: 30,fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto')))),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container( height: 40,child: Align( alignment: Alignment.center,
                          child: Text("Brings to You",style: TextStyle(color: Colors.indigo[900],fontSize: 20,
                              fontFamily: 'Roboto')),
                        )),
                      ),
                    ]),
              ),
              Container(
                width: double.infinity,
                child: Card(
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
                        child: Container(color: Colors.indigo[800],
                            height: 40,
                            child: Center(child: Text('DATE: ${DateFormat("dd-MM-yyyy").format(deets.time)}' ,style: TextStyle(color: Colors.white,
                                fontFamily: 'Roboto')))
                        ), flex:1
                    ),

                    Expanded(child: Container(color: Colors.indigo[800],
                        height: 40,
                        child: Center(child: Text("VENUE: "+ deets.venue ,style: TextStyle(color: Colors.white,
                            fontFamily: 'Roboto')))
                    ),flex: 1,),
                  ]),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(deets.desc, style: TextStyle(color: Colors.indigo[800],fontSize: 15,
                      fontFamily: 'Roboto')
                  ),
                ),
              ),
              SizedBox(height: 20),
              Image.network('${deets.imgURL}'),
            ]),
      ),
    );
  }

  Widget futureBuilder() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Events').snapshots(),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                heightFactor: 10,
                widthFactor: 10,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.indigo[700]),
                ),
              );

            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.indigo[700]),
                ),
              );

            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                print(snapshot.data.documents);
               return _buildPost(context, snapshot.data.documents[0]);
          }
        });
  }
  
  @override
  Widget build(BuildContext context) {
    return futureBuilder();
  }
}


class PostDeets{
  String title, venue, desc, imgURL, group; DateTime time;
  PostDeets(this.title, this.time, this.venue, this.desc, this.imgURL,
      this.group);
}
