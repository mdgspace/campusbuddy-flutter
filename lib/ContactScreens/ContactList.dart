import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ContactList extends StatelessWidget {
  String sub="sub";
  static Color color = const Color(0xFF303E84);
  List<String> phno=["hello","bye","hey","due","here","there","mare","dare"];
  ContactList({Key key,this.title}) :super(key:key);
  static String assetName = 'assets/contactPerson.svg';
  static String assetNameAcad = 'assets/acad.svg';
  String title;
  final Widget svgIcon = SvgPicture.asset(
      assetName,
      color: color,
      width: 42,
      height: 42,
  );
  final Widget svgIconAcad = Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child:SvgPicture.asset(
      assetNameAcad,
      color: Colors.white,
      width: 42,
      height: 42,
  ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            expandedHeight: 215.3,
            backgroundColor: color,
            flexibleSpace:FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
             title,
                style: TextStyle(
                  fontSize: 17,

                ),
              ),
            background:svgIconAcad,

            ),
        )
          ,
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
                  (context, index)  {return Padding(
                    padding: EdgeInsets.all(8),
                    child: Card(

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                        mainAxisAlignment: MainAxisAlignment.start
                        ,
                            children: [
                              Padding(
                                  padding:EdgeInsets.fromLTRB(12, 17, 12, 17),
                                  child: svgIcon),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(phno[index],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  Text(sub,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black38,
                                  ),)
                                ],
                              )
                            ],
                      ),
                              IconButton(
                                icon: Icon(Icons.arrow_right),
                                onPressed: () {

                                },
                              )
                        ],
                      ),
                    ),
                  );},
              // Builds 1000 ListTiles
              childCount: phno.length,
            ),
          )
        ],
      ),
    );
  }
  }