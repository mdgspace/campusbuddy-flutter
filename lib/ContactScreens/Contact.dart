import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class Contact extends StatelessWidget {
 static String sub="sub",department="Biotechnology",name="Name",typeOfCall="type | of call ";
  static Color color = const Color(0xFF303E84);
  List<String> phno=["hello","bye","hey","due"];
  static String assetName = 'assets/contactPerson.svg';
  static String assetNameAdd = 'assets/addContact.svg';
  final Widget svgIcon = SvgPicture.asset(
      assetName,
      color: Colors.white,
      width: 42,
      height: 42,
  );
  final Widget svgIconAdd = SvgPicture.asset(
      assetNameAdd,
      color: Colors.white,
      width: 42,
      height: 42,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        elevation: 0,
        actions: [
          IconButton(
            icon: svgIconAdd,
            onPressed: (){
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
      children: [Container(
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child:
                Padding(
                    padding: EdgeInsets.all(10),
                    child: svgIcon),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 4, color: Colors.white)
                ,
                  color: color,
                ),

              ),
            SizedBox(
              height: 9.2,
            ),
              Text(name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.2,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(
                height: 20,
              ),
              Text(department,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.2
                ),),
              SizedBox(
                height: 22,
              ),
              Text(sub,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.2
                ),)
             , SizedBox(
                height: 9,
              ),
            ],
          ),
        ),
      ),
       Flexible(

         child: Padding(
          padding: EdgeInsets.fromLTRB(13.5, 8.5, 13.5, 0),
          child:  new ListView.builder
            (
              itemCount: phno.length,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  child:Padding(
                    padding: EdgeInsets.fromLTRB(12, 16, 0, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(phno[index]
                        ,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                        ),),
                        SizedBox(
                          height: 5.25,
                        ),
                        Text(typeOfCall, style: TextStyle(
                          color: Colors.black38,
                          fontSize: 17.52
                        ),),

                      ],
                    ),
                  ),
                );
              }
          ),
      ),
       ),]
    )
    );
  }
}
