import 'post_screen/post.dart';
import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

//void main() => runApp(Calendar());

class Calendar extends StatelessWidget {
  final PostDeets calendar;
  Calendar(this.calendar);
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print(calendar.title);
    //event object is created, pass it title and description
    Event event = Event(
      title: calendar.title,
      description: calendar.desc,
      location: 'Flutter app',
      startDate:calendar.time,
      endDate: calendar.time.add(Duration(minutes: 5)),
      allDay: false,
    );

    return  Center(
          child: RaisedButton(
            elevation: 3,
            highlightElevation: 6,
            child: Text('Add Event to your calendar?',style: TextStyle(
                color: Colors.white,fontStyle: FontStyle.italic,fontWeight: FontWeight.w600),),
            //this is the method we have to call when user clicks on fab
            color: Colors.indigo[700],
            onPressed: () {
              Add2Calendar.addEvent2Cal(event).then((success) {
                scaffoldState.currentState.showSnackBar(
                    SnackBar(content: Text(success ? 'Success' : 'Error')));
              });
            },
          ),
        );
  }
}
