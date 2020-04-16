import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campusbuddy/Directory/Models.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Directory  extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Directory>{


  @override
  void initState() {
    super.initState();
  }

  final dbRef =  FirebaseDatabase.instance.reference();
  final makecall= new MakeCall();

  @override
  Widget build(BuildContext context) {


    var futureBuilder= new FutureBuilder(

        future:  makecall.firebaseCalls(dbRef),

        builder: (BuildContext context, AsyncSnapshot snapshot) {
         // print('left the makecall fun');
          
          switch (snapshot.connectionState) {
            case ConnectionState.none: return new Text('Press button to start');
            case ConnectionState.waiting: return new Text('Loading....');
            default:
              if (snapshot.hasError)

                return new Text('Error: ${snapshot.error}');
              else {
                return
                  Column(
                      children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot?.data?.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Card(
                                           child: new ListTile(
                                             leading: SvgPicture.asset('assets/images/icon.svg',color: Colors.indigo[900]),
                                             title:Text('${snapshot?.data[index]?.itemName}'),
                                             trailing: Icon(Icons.keyboard_arrow_right),
                            )
                        );
                      })??[ ],
                ),

                  ],
          );
              }
          }
        });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[800],
        title: Text("Telephone Directory"),
        actions: <Widget>[
          IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
               onPressed: () async {
             //  final int selected = await showSearch<int>();
          }
      ),
        ],
      ),
      body: Column(
        children: <Widget>[

          Expanded(child: futureBuilder),


        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Colors.indigo[800],// this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.phone,color: Colors.white),
            title: new Text('Contacts',style: TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto'
            ),
            ),


          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.notifications_active,color: Colors.white),
            title: new Text('Notices',style: TextStyle(
              color: Colors.white,
                fontFamily: 'Roboto'
            )),

          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz,color: Colors.white),
              title: Text('More',style: TextStyle(color: Colors.white,fontFamily: 'Roboto'))
          )
        ],
      ),
    );
  }
}

