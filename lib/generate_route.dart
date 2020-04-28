import 'package:campusbuddy/Blank.dart';
import 'package:campusbuddy/Directory/Directory.dart';
import 'package:campusbuddy/auth/auth.dart';
import 'package:campusbuddy/auth/root_page.dart';
import 'package:campusbuddy/screens/department_list.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
