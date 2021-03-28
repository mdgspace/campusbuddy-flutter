import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'post_screen/events.dart';

class ScheduleNotification extends StatefulWidget {
  final Deets notifs;

  ScheduleNotification(this.notifs);

  @override
  _ScheduleNotificationState createState() =>
      new _ScheduleNotificationState(notifs);
}

class _ScheduleNotificationState extends State<ScheduleNotification> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Deets notifs;

  _ScheduleNotificationState(this.notifs);

  static const Color indigo = const Color(0xff303E84);

  //code to initialize plugin
  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.indigo[700],
          onPrimary: Colors.white,
          elevation: 3,
          visualDensity: VisualDensity(horizontal: 6.0, vertical: 6.0),
        ),
        onPressed: () async => Alertdialog(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Notify me ',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            IconButton(icon: SvgPicture.asset('assets/bell.svg')),
          ],
        ),
      ),
    );
  }

//method to schedule notifications, give it date and time arguments retrieved from db
// and an int value for fixing alert-before time interval.
  Future<void> _scheduleNotification(int alert) async {
    var scheduledNotificationDateTime =
        (notifs.time).subtract(Duration(minutes: alert));
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('campusbuddy', 'campusbuddy', 'campusbuddy');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Event: ${notifs.title}",
        'Venue: ${notifs.venue}, Conducted by: ${notifs.group}',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  //PopUP Widget that allows user to choose when to be alerted before Event
  void Alertdialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // returns object of type Dialog
        return AlertDialog(
          title: Center(
              child: Text(
            "Notify me:",
            style: TextStyle(color: indigo, fontSize: 30),
          )),
          shape: RoundedRectangleBorder(),
          actions: <Widget>[
            TextButton(
              child: Center(
                  child: Text(
                "15 minutes before Event",
                style: TextStyle(color: Colors.blue[700], fontSize: 20),
              )),
              onPressed: () {
                _scheduleNotification(15);
                FlutterToast();
              },
            ),
            TextButton(
              child: Center(
                  child: Text(
                "30 minutes before Event",
                style: TextStyle(color: Colors.blue[700], fontSize: 20),
              )),
              onPressed: () {
                _scheduleNotification(30);
                FlutterToast();
              },
            ),
            TextButton(
              child: Center(
                  child: Text(
                "1 Hour before Event",
                style: TextStyle(color: Colors.blue[700], fontSize: 20),
              )),
              onPressed: () {
                _scheduleNotification(60);
                FlutterToast();
              },
            )
          ],
        );
      },
    );
  }

//Toast to confirm successfully added notification.
  void FlutterToast() {
    Fluttertoast.showToast(
        msg: "SUCCESSFUL",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: indigo,
        textColor: Colors.white);
    Navigator.pop(context);
  }
}
