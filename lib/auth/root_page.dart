import 'package:campusbuddy/directory/directory.dart';
import 'package:campusbuddy/directory/directory_list_widget.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'auth.dart';
import 'home_page.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}


class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);

  final Auth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
{
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new Login(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;

      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return Directory(
          );
        } else
          return buildWaitingScreen();

        break;
      default:
        return buildWaitingScreen();

    }
  }
}

