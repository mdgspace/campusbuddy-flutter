
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';


void main() {
  runApp(
    new MaterialApp(home: ScheduleNotification()),
  );
}

class ScheduleNotification extends StatefulWidget {
  @override
  _ScheduleNotificationState createState() => new _ScheduleNotificationState();
}

class _ScheduleNotificationState extends State<ScheduleNotification>
{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  //code to initialize plugin
  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: ()
            {
              _scheduleNotification();
            },
            child: Text(
                'Schedule Notification'
            ),
          ),

        ],
      )
    );
  }


//method to schedule notifications, give it date and time arguments retrieved from db
  Future<void> _scheduleNotification() async {
    var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('campusbuddy',
        'campusbuddy', 'campusbuddy');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'show title here',
        'show body here',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
}