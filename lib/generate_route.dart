import 'package:campusbuddy/Blank.dart';
import 'package:campusbuddy/ContactScreens/Contact.dart';
import 'package:campusbuddy/ContactScreens/ContactList.dart';
import 'package:campusbuddy/Directory/Directory.dart';
import 'package:campusbuddy/auth/auth.dart';
import 'package:campusbuddy/auth/root_page.dart';
import 'package:campusbuddy/screens/department_list.dart';
import 'package:flutter/material.dart';

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
        return MaterialPageRoute(builder: (_) => Directory());
      default:
        return MaterialPageRoute(builder: (_) => Blank());
    }
  }
}
