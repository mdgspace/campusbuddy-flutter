import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campusbuddy/directory/blank.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campusbuddy/directory/directory_list_widget.dart';
import 'package:campusbuddy/post_screen/post.dart';
class Directory extends StatefulWidget
{
  Directory({Key key}) : super(key: key);

  @override
  _DirectoryState createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
int _currentIndex=0;
final _selectedBgColor = Colors.indigo[900];
final _unselectedBgColor = Colors.indigo[700];
final List<Widget> _children =[
 DirectoryList(),
 Post(),
  Blank()
];

void onTabTapped(int index){
  setState(() {
    _currentIndex=index;
  });
}

Color _getBgColor(int index)=>
    _currentIndex==index ? _selectedBgColor:_unselectedBgColor;

Widget _buildIcon(IconData iconData, String text, int index)=>
    Container(
       width: double.infinity,
       height: kBottomNavigationBarHeight,
       child: InkWell(
         onTap: ()=>onTabTapped(index),
         child: Material(
          color: _getBgColor(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData,color: Colors.white,),
                Text(text,style: TextStyle(color: Colors.white,
                    fontFamily: 'Roboto'))
              ],
            ),
          ),
       ),
     );



  @override
  Widget build(BuildContext context) {
    return
      Scaffold(

        body: _children[_currentIndex],
        
        bottomNavigationBar: SizedBox(
          child: BottomNavigationBar(
              selectedFontSize: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: _buildIcon(Icons.phone, 'Contacts', 0),
                    title: SizedBox.shrink(),
                ),
                BottomNavigationBarItem(
                  title: SizedBox.fromSize(),
                  icon: _buildIcon(Icons.notifications_active, 'Notifications', 1)),
                BottomNavigationBarItem(
                  icon: _buildIcon(Icons.more_horiz, 'More', 2),
                  title: SizedBox.fromSize(),
                )
              ],
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            ),

),
      );

  }
}
