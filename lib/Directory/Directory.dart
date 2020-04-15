import 'package:flutter/material.dart';

class Directory  extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Directory>{

  final DirectoryList=['Academic Departments & Centres','Employee Associations & Clubs','Hostels',
                        'Internal Services','Offices','Other Institutes','Saharanpur Campus',
                        'Selected Local Numbers','Student Affairs Council','Student Activities'];

  @override
  Widget build(BuildContext context) {

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

      body: ListView.builder(
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
                  leading: Icon(Icons.account_balance,color: Colors.indigo[900],),
                  title: Text(DirectoryList[index]),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
            );
          },
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

