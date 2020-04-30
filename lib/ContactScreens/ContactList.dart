import 'package:campusbuddy/ContactScreens/Contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactList extends StatelessWidget {
  static const routeName = '/ContactList';
  static const Color color = const Color(0xff303e84);
  static const String assetName = 'assets/contactPerson.svg';
  static const String assetNameAcad = 'assets/acad.svg';
  static const String assetNameArrow = 'assets/arrow.svg';
  static String title='Department';
  static String pathId2;
  final  title2;
  final pathId;
  static Widget svgIcon = SvgPicture.asset(
    assetName,
    color: color,
    width: 42.w,
    height: 42.h,
  );
  static Widget svgArrowIcon = SvgPicture.asset(
    assetNameArrow,
    color: Color(0xff3B3B3B),
    width: 5.5.w,
    height: 11.3.h,
  );

  static Widget svgIconAcad = Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: SvgPicture.asset(
        assetNameAcad,
        color: Colors.white,
        width: 42.w,
        height: 42.h,
      ));
  ContactList({Key key,@required this.title2,@required this.pathId})
      :super(key:key);
 static void _fillDetail(context, DocumentSnapshot documents) {
    String office = "", email = "", residence = "", contactName = "";
    if (documents['office'].toString() != "[]") {
      office = documents['office'][0].toString();
    }
    if (documents['email'].toString() != "[]") {
      email = documents['email'][0].toString();
    }
    if (documents['residence'].toString() != "[]") {
      residence = documents['residence'][0].toString();
    }
    contactName = documents['contact_name'].toString();
    PassToContact pass = new PassToContact(office, email, residence,
        contactName, documents['designation'].toString(), ContactList.title);
    Navigator.of(context).pushNamed(Contact.routeName, arguments: pass);
  }

  Widget futureBuilder() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(
            '${ContactList.pathId2}/contacts')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                heightFactor: 10,
                widthFactor: 10,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              );

            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              );

            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      snap: true,
                      expandedHeight: 215.3.h,
                      backgroundColor: ContactList.color,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(
                          '${ContactList.title}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(17),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),

                        background: ContactList.svgIconAcad,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        // The builder function returns a ListTile with a title that
                        // displays the index of the current item.
                            (context, index) {
                          DocumentSnapshot documents =
                          snapshot.data.documents[index];
                          return Padding(
                              padding: EdgeInsets.fromLTRB(13.5, 8, 13.5, 0),
                              child: GestureDetector(
                                onTap: () {
                                  _fillDetail(context, documents);
                                },
                                child: Card(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    12, 17, 12, 17),
                                                child: ContactList.svgIcon),
                                            Flexible(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${documents['contact_name']}',
                                                    style: TextStyle(
                                                      fontSize:
                                                      ScreenUtil().setSp(17),
                                                      fontWeight:
                                                      FontWeight.normal,
                                                    ),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                  Text(
                                                    '${documents['designation']}',
                                                    style: TextStyle(
                                                      fontSize:
                                                      ScreenUtil().setSp(17),
                                                      color: Colors.black38,
                                                    ),
                                                    overflow: TextOverflow.clip,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: ContactList.svgArrowIcon,
                                        onPressed: () {
                                          _fillDetail(context, documents);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        },
                        childCount: snapshot.data.documents.length,
                      ),
                    ),
                    SliverFillRemaining(
                      child: Text(""),
                    )
                  ],
                );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    ContactList.title=title2;
    ContactList.pathId2=pathId;
    ScreenUtil.init(context, allowFontScaling: true, width: 410, height: 703);
    return Scaffold(
      body: futureBuilder(),
    );
  }
}

class PassToContact {
  String office, email, residence, name, sub, department;
  PassToContact(this.office, this.email, this.residence, this.name, this.sub,
      this.department);
}
