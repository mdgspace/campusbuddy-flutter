import 'package:campusbuddy/directory/blank.dart';
import 'package:campusbuddy/ContactScreens/Contact.dart';
import 'package:campusbuddy/ContactScreens/ContactList.dart';
import 'package:campusbuddy/directory/directory.dart';
import 'package:campusbuddy/auth/auth.dart';
import 'package:campusbuddy/auth/root_page.dart';
import 'package:campusbuddy/post_screen/events.dart';
import 'package:campusbuddy/post_screen/posts.dart';
import 'package:campusbuddy/screens/department_list.dart';
import 'post_screen/events.dart';
import 'package:flutter/material.dart';
import 'package:campusbuddy/directory/chat_screen.dart';
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ContactList.routeName:
        final Map args = settings.arguments;
        return MaterialPageRoute(builder: (_) => ContactList(
          title2: args['dept_name'],
          pathId: args['dept_id'],
        ));
      case Contact.routeName:
        final PassToContact pass = settings.arguments;
        return MaterialPageRoute(builder: (_) => Contact(pass));
      case DepartmentListPage.routeName:
        final Map args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => DepartmentListPage(
            groupDocID: args['group_id'],
            groupName: args['group_name'],
          ),
        );
      case RootPage.routeName:
        return MaterialPageRoute(
          builder: (_) => RootPage(
            auth: Auth(),
          ),
        );
      case Directory.routeName:
        return MaterialPageRoute(
            builder: (_) => Directory());
      case Events.routeName:
        final Deets deets = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => Events(deets));
      case Posts.routeName:
        final Deets deets = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => Posts(deets));
      case ChatScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => ChatScreen());
        default:
        return MaterialPageRoute(builder: (_) => Blank());
    }
  }
}
