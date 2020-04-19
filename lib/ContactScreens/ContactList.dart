import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:campusbuddy/ContactScreens/ContactListElement.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ContactList extends StatefulWidget {
  static Color color = const Color(0xff303e84);
  static String assetName = 'assets/contactPerson.svg';
  static String assetNameAcad = 'assets/acad.svg';
  static String assetNameArrow = 'assets/arrow.svg';
  @override
  _ContactListState createState() => _ContactListState();
}
class _ContactListState extends State<ContactList> {
  final databaseReference = FirebaseDatabase.instance.reference();
  static String title="BioTechnology";
  static Widget svgIcon = SvgPicture.asset(
      ContactList.assetName,
      color: ContactList.color,
      width: 42.w,
      height: 42.h,
  );
  static Widget svgArrowIcon = SvgPicture.asset(
    ContactList.assetNameArrow,
    color: Color(0xff3B3B3B),
    width: 5.5.w,
    height: 11.3.h,
  );
  static Widget svgIconAcad = Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child:SvgPicture.asset(
      ContactList.assetNameAcad,
      color: Colors.white,
      width: 42.w,
      height: 42.h,
  ));
  static final dbRef =  FirebaseDatabase.instance.reference();
  static final makecall= new MakeCall();
  static var futureBuilder=new FutureBuilder(
      future:  makecall.firebaseCalls(dbRef), // async work
      // ignore: top_level_function_literal_block
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none: return Text("INTERNET Not There");
          case ConnectionState.waiting: return Center(
            child: new LoadingBouncingGrid.square(
              borderColor: Colors.cyan,
              backgroundColor: Colors.blue,
              duration: Duration(milliseconds: 400),
            ),
          );
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return CustomScrollView(
                slivers: <Widget>[SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: true,
                  expandedHeight: 215.3.h,
                  backgroundColor: ContactList.color,
                  flexibleSpace:FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    background:svgIconAcad,
                  ),
                ),
                  SliverList(
                    // Use a delegate to build items as they're scrolled on screen.
                    delegate: SliverChildBuilderDelegate(
                      // The builder function returns a ListTile with a title that
                      // displays the index of the current item.
                          (context, index)  {return Padding(
                          padding: EdgeInsets.fromLTRB(13.5, 8, 13.5, 0),
                          child: GestureDetector(
                            onTap: (){
                              PassToContact pass=new PassToContact(snapshot.data[index].office.toString(),snapshot.data[index].email.toString(),snapshot.data[index].residence.toString(),snapshot.data[index].name.toString(),snapshot.data[index].sub.toString(),title);
                              Navigator.pushNamed(context, '/Contact',arguments: pass);
                            },
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
                                          Text('${snapshot.data[index].name}',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(17),

                                              fontWeight: FontWeight.normal,
                                            ),),
                                          Text('${snapshot.data[index].sub}',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(17),
                                              color: Colors.black38,
                                            ),)
                                        ],
                                      )
                                    ],
                                  ),
                                  IconButton(
                                    icon: svgArrowIcon,
                                    onPressed: () {
                                      print(snapshot.data[index].name);
                                      print("hello");
                                      PassToContact pass=new PassToContact(snapshot.data[index].office.toString(),snapshot.data[index].email.toString(),snapshot.data[index].residence.toString(),snapshot.data[index].name.toString(),snapshot.data[index].sub.toString(),title);
                                  Navigator.pushNamed(context, '/Contact',arguments: pass);
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                      );},
                      // Builds 1000 ListTiles
                      childCount:snapshot.data.length,
                    ),
                  ),
                  SliverFillRemaining(
                    child: Text(""),
                  )
                ],
              );
        }
      });
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,allowFontScaling: true, width: 410, height: 703);
    return Scaffold(
      body:futureBuilder,
    );
  }
}
class PassToContact{
  String office,email,residence,name,sub,department;
  PassToContact(this.office,this.email,this.residence,this.name,this.sub,this.department);
}