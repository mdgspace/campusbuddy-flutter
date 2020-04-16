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

  final DirectoryList=['Academic Departments & Centres','Employee Associations & Clubs','Hostels',
                        'Internal Services','Offices','Other Institutes','Saharanpur Campus',
                        'Selected Local Numbers','Student Affairs Council','Student Activities'];
  @override
  void initState() {
    super.initState();
  }

  final dbRef =  FirebaseDatabase.instance.reference();
  final makecall= new MakeCall();

  @override
  Widget build(BuildContext context) {

    var futureBuilder=new FutureBuilder(
        future:  makecall.firebaseCalls(dbRef), // async work
        builder: (BuildContext context, AsyncSnapshot snapshot) {
           // print('${snapshot.data.length}');
          switch (snapshot.connectionState) {
            case ConnectionState.none: return new Text('Press button to start');
            case ConnectionState.waiting: return new Text('Loading....');
            default:
              if (snapshot.hasError)

                return new Text('Error: ${snapshot.error}');
              else
                return ListView.builder(
                    itemCount: snapshot?.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: new ListTile(
                            leading: SvgPicture.asset('assets/images/icon.svg',color: Colors.indigo[900]),
                            title:Text('${snapshot?.data[index]?.itemName}'),
                            trailing: Icon(Icons.arrow_forward),
                          )
                      );
                    })??[ ];
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
               final int selected = await showSearch<int>(
               );
          }
      ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: DirectoryList.length,
                itemBuilder: (context, index){
                  return Card(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          print('tapped once');
                        });
                      },
                      child: ListTile(
                        leading: SvgPicture.asset('assets/images/icon.svg',color: Colors.indigo[900]),
                        title: Text(DirectoryList[index]),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  );
                },
            ),
          ),
          SizedBox(height: 10,),
          new Container(
              child: Column(
            children: <Widget>[
              futureBuilder,
            ]
          ),
          ),
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

