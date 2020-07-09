
import 'package:flutter_svg/flutter_svg.dart';

import 'post_screen/events.dart';
import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

//void main() => runApp(Calendar());

class Calendar extends StatefulWidget {
  final Deets calendar;

  Calendar(this.calendar);


  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  static const Color indigo = const Color(0xff303E84);

  @override
  Widget build(BuildContext context) {

    //event object is created, pass it title and description
    Event event = Event(
      title: widget.calendar.title,
      description: widget.calendar.desc,
      location: 'Flutter app',
      startDate:widget.calendar.time,
      endDate: widget.calendar.time.add(Duration(minutes: 5)),
      allDay: false,
    );

    return  Container(
      height: 60,
          child: RaisedButton(
            elevation: 6,
            color: indigo,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text('Add to Calendar ', style: TextStyle(
                      color: Colors.white,fontSize: 17
                  ),),
                ),
                IconButton
                  (icon:SvgPicture.asset('assets/calendar.svg')),

              ],
            ),
            //this is the method we have to call when user clicks on fab
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
