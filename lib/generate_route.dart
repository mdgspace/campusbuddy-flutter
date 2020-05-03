import 'package:campusbuddy/directory/Blank.dart';
import 'package:campusbuddy/ContactScreens/Contact.dart';
import 'package:campusbuddy/ContactScreens/ContactList.dart';
import 'package:campusbuddy/directory/directory.dart';
import 'package:campusbuddy/auth/auth.dart';
import 'package:campusbuddy/auth/root_page.dart';
import 'package:campusbuddy/post_screen/post.dart';
import 'package:campusbuddy/post_screen/post2.dart';
import 'package:campusbuddy/screens/department_list.dart';
import 'post_screen/post.dart';
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
        return MaterialPageRoute(
            builder: (_) => Directory());
      case Post.routeName:
        final PostDeets postDeets = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => Post(postDeets));
      case Post2.routeName:
        final PostDeets postDeets2 = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => Post2(postDeets2));
      default:
        return MaterialPageRoute(builder: (_) => Blank());


    }
  }
}
