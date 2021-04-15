import 'package:campusbuddy/search_feature/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactView extends StatelessWidget {
  final Contact contact;

  ContactView({this.contact});

  @override
  Widget build(BuildContext context) {
    Widget cardwidget(String value, String label, Function onTap) {
      return Card(
        child: GestureDetector(
          onTap:onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                  child: Text(
                    '$value'??'',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                  child: Text(
                    '$label'??'',
                    style: TextStyle(fontSize: 17, color: Color(0xFF838383)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final Widget svgIcon = SvgPicture.asset(
      'assets/contactPerson.svg',
      color: Colors.white,
      width: 42,
      height: 42,
    );

   Future<void> _makePhoneCall(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    Future<void> _makeEmail(String url) async {
      final Email email = Email(
        recipients: ['$url'],
        isHTML: false,
      );
      String platformResponse;
      try {
        await FlutterEmailSender.send(email);
        platformResponse = 'success';
      } catch (error) {
        platformResponse = error.toString();
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff303e84),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
         Container(
           width: double.infinity,
           color: Color(0xff303e84),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               Container(
                 child: Padding(
                   padding: EdgeInsets.all(10),
                   child: svgIcon,
                 ),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(50),
                   border: Border.all(width: 4, color: Colors.white),
                   color: Color(0xff303e84),
                 ),
               ),
               SizedBox(
                 height: 9.2,
               ),
               Text(
                 contact.name??'',
                 style: TextStyle(
                   color: Colors.white,
                   fontSize:20,
                   fontWeight: FontWeight.bold,
                 ),
                 textAlign: TextAlign.left,
               ),
               SizedBox(
                 height: 20,
               ),
               Text(
                 contact.department_name??'',
                 style: TextStyle(
                     color: Colors.white, fontSize: 17),
               ),
               SizedBox(
                 height: 22,
               ),
               Text(
                 contact.desg??'',
                 style: TextStyle(
                     color: Colors.white, fontSize: 17),
               ),
               SizedBox(
                 height: 9,
               ),
             ],
           ),
         ),
          contact.iitrO != null
              ? cardwidget(contact.iitrO[0], 'Main | Office',(){_makePhoneCall('tel:${contact.iitrO[0]}');})
              : Container(),
          contact.iitrR != null
              ? cardwidget(contact.iitrR[0], 'Main | Residence',(){_makePhoneCall('tel:${contact.iitrR[0]}');})
              : Container(),
          contact.email != null
              ? cardwidget(contact.email[0], 'IITR Email',(){_makeEmail(contact.email[0]);})
              : Container(),
        ],
      ),
    );
  }
}
