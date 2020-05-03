import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'post_screen/post.dart';


class ScheduleNotification extends StatefulWidget {
  final PostDeets notifs;
  ScheduleNotification(this.notifs);

  @override
  _ScheduleNotificationState createState() => new _ScheduleNotificationState(notifs);
}

class _ScheduleNotificationState extends State<ScheduleNotification> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final PostDeets notifs;
  _ScheduleNotificationState(PostDeets deets,{@required this.notifs});

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
    return
            Center(
              child: RaisedButton(
                color: Colors.indigo[700],
                elevation: 3,
                highlightElevation: 6,
                onPressed: ()
                {
                  _scheduleNotification();
                },
                child: Text(
                    'Schedule Notification?',style: TextStyle(
                    color: Colors.white,fontStyle: FontStyle.italic,fontWeight: FontWeight.w600),
                ),
                ),
            );
  }


//method to schedule notifications, give it date and time arguments retrieved from db
  Future<void> _scheduleNotification() async {
    var scheduledNotificationDateTime = notifs.time.add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('campusbuddy',
        'campusbuddy', 'campusbuddy');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        "Event: ${notifs.title}",
        'Venue: ${notifs.venue}, Conducted by: ${notifs.group}',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
}
