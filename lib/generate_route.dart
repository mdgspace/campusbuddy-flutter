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
    }
  }
}
