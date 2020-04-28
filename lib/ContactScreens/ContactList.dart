import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactList extends StatelessWidget {
  static Color color = const Color(0xff303e84);
  static String assetName = 'assets/contactPerson.svg';
  static String assetNameAcad = 'assets/acad.svg';
  static String assetNameArrow = 'assets/arrow.svg';
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

  static var futureBuilder=new  StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('/groups/vPWCIkNPlM9zshNYhpqm/departments/2Taj5LPxdTEVIoKzmtkQ/contacts')
          .snapshots(),
      // ignore: top_level_function_literal_block
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {

        switch (snapshot.connectionState) {
          case ConnectionState.none: return Center(
            heightFactor: 10,
            widthFactor: 10,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          );

          case ConnectionState.waiting: return Center(
            child: new LoadingBouncingGrid.square(
              borderColor: Colors.indigo[900],
              backgroundColor: ContactList.color,
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
                          (context, index)  {
                            DocumentSnapshot documents=snapshot.data.documents[index];
                            print("hello" + documents.toString());
                            return Padding(
                            padding: EdgeInsets.fromLTRB(13.5, 8, 13.5, 0),
                          child: GestureDetector(
                            onTap: (){
                              String office = "",email = "",residence = "",contactName = "";
                              if(documents['office'].toString() != "[]"){
                              office = documents['office'][0].toString();}
                              if(documents['email'].toString() != "[]"){
                              email = documents['email'][0].toString();}
                              if(documents['residence'].toString() != "[]"){
                              residence = documents['residence'][0].toString();}
                              contactName = documents['contact_name'].toString();
                              PassToContact pass = new PassToContact(office,email,residence,contactName,documents['designation'].toString(),title);
                              Navigator.pushNamed(context, '/Contact',arguments: pass);
                            },
                            child: Card(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding:EdgeInsets.fromLTRB(12, 17, 12, 17),
                                            child: svgIcon),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('${documents['contact_name']}',
                                                style: TextStyle(
                                                  fontSize: ScreenUtil().setSp(17),
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              overflow: TextOverflow.clip,
                                              ),
                                              Text('${documents['designation']}',
                                                style: TextStyle(
                                                  fontSize: ScreenUtil().setSp(17),
                                                  color: Colors.black38,
                                                ),
                                              overflow: TextOverflow.clip,)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: svgArrowIcon,
                                    onPressed: () {
                                      DocumentSnapshot documents=snapshot.data.documents[index];
                                      PassToContact pass=new PassToContact(documents['office']['0'].toString(),documents['email']['0'].toString(),documents['residence']['0'].toString(),documents['contact_name'].toString(),documents['designation'].toString(),title);
                                      Navigator.pushNamed(context, '/Contact',arguments: pass);
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                      );},
                      // Builds 1000 ListTiles
                      childCount:snapshot.data.documents.length,
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