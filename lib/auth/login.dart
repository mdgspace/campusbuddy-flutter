
import 'package:campusbuddy/Directory/DirectoryListWidget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'home_page.dart';
import 'signup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'globals.dart';
import 'package:campusbuddy/Directory/Directory.dart';



class Login extends StatefulWidget{
  final Auth auth;
  final VoidCallback loginCallback;

Login({Key key, this.auth, this.loginCallback}) : super(key: key);



  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  bool passwordVisible;
  String _errorMessage;
  bool _isLoading=false;
  String emailReset='';
  bool isReset=false;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        userId = await widget.auth.signIn(_email, _password);
        print('Signed up user: $userId');
        setState(() {
          _isLoading = false;
        });

        if ( userId != null && userId.length > 0) {
          widget.loginCallback();
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) => Directory()),
              ModalRoute.withName('/'));

        }
      } catch (e) {
        print('Error: $e');
        Fluttertoast.showToast(
            msg:INCORRECT_USER_PASSWORD,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true)
        );
        setState(() {
          _isLoading = false;
          _formKey.currentState.reset();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = "";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 410, height: 703, allowFontScaling: true);
    return MaterialApp(
      home: Scaffold(
        body:  Container(
          height: double.infinity,
          width: double.infinity,
          color: Color(0xFF303E84),
      child: Stack(
        children: <Widget>[
             _showForm(),
              showCircularProgress(),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
               child: showMDG(),
            ),
          )

        ],

      ),
    ),
      ),
    );
  }

  Widget Logo()
  {
     return  Column(
       children: <Widget>[
         Container(
           margin:EdgeInsets.only(left: ScreenUtil().setWidth(145),top: ScreenUtil().setWidth(70), right: ScreenUtil().setWidth(145)) ,
           child:  new SvgPicture.asset(
             'assets/cap.svg',
             allowDrawingOutsideViewBox: true,
           ),
         ),
         Container(
           margin:EdgeInsets.only(left: ScreenUtil().setWidth(140),right: ScreenUtil().setWidth(145)) ,
           child:  new SvgPicture.asset(
             'assets/goggles.svg',
             allowDrawingOutsideViewBox: true,
           ),
         ),
         Container(
           margin: EdgeInsets.only(top: ScreenUtil().setWidth(15),
             left:ScreenUtil().setWidth(40) ,
           ),
           child: Text(
             CAMPUS_BUDDY,
                    style: GoogleFonts.pacifico(
                        textStyle: TextStyle(
                            fontSize:
                            ScreenUtil().setSp(30, allowFontScalingSelf: true),
                            color:Colors.white)),
           ),
         ),
       ],
     );
  }


  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding:EdgeInsets.only(left:ScreenUtil().setWidth(30), top:ScreenUtil().setWidth(50), right:ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(0)),
      child: new TextFormField(
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
        ),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: HINT_EMAIL,
        hintStyle:  GoogleFonts.roboto(
        textStyle: TextStyle(
        fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
          color: Color.fromRGBO(255, 255, 255, 0.4),)),
            icon: new Icon(
              Icons.person,
              color: Colors.white,
            ),
           enabledBorder: UnderlineInputBorder(
           borderSide: BorderSide(color: Colors.white),),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
       // validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding:EdgeInsets.only(left:ScreenUtil().setWidth(30), top:ScreenUtil().setWidth(30), right:ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(0)),
      child: new TextFormField(
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
        ),
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
            hintText: HINT_PASSWORD,
            hintStyle:  GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                  color: Color.fromRGBO(255, 255, 255, 0.4),)),
            icon: new Icon(
              Icons.lock,
              color: Colors.white,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
       // validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showLoginButton() {
    return new Container(
       margin: EdgeInsets.only(left: ScreenUtil().setWidth(120),
                     right: ScreenUtil().setWidth(120),
                     top: ScreenUtil().setWidth(45),
                     bottom: ScreenUtil().setWidth(50)),
        child: SizedBox(
          //height: 45.0,
          child: new FlatButton(
            onPressed: validateAndSubmit,
            shape: new RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.white,
                  style: BorderStyle.solid,
                width: 1
              ),
                borderRadius: new BorderRadius.circular(30.0),
            ),
           child: Container(
             padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(5),
               ScreenUtil().setWidth(8),
               ScreenUtil().setWidth(5),
               ScreenUtil().setWidth(8),),
             child: new Text(LOGIN,
               style: GoogleFonts.roboto(
                 textStyle: TextStyle(
                     fontSize: ScreenUtil().setSp(22, allowFontScalingSelf: true),
                     fontWeight: FontWeight.w500,
                     color: Colors.white),),
               //  onPressed: validateAndSubmit,
             ),
           ),
        )));
  }


  Widget FogotPassword()
  {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(80),
          right: ScreenUtil().setWidth(80),),
      child: FlatButton(
        onPressed: ()
        {
          showEnterEmailDialog();
        },
        child: Text(
          FORGOT_PASSWORD,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: ScreenUtil().setSp(16),
              )
            ),
        ),
      ),
    );
  }

  Widget showSignupButton() {

    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(120),
          right: ScreenUtil().setWidth(120),
          top: ScreenUtil().setWidth(20),),
        child: FlatButton(
          shape: new RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.white,
                style: BorderStyle.solid,
                width: 1
            ),
            borderRadius: new BorderRadius.circular(30.0),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignupPage(
                      auth: widget.auth,
                      loginCallback: widget.loginCallback)),
            );
          },

          child: Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(5),
              ScreenUtil().setWidth(8),
              ScreenUtil().setWidth(5),
              ScreenUtil().setWidth(8),),
            child: new Text(SIGN_UP,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(22, allowFontScalingSelf: true),
                    fontWeight: FontWeight.w500,
                    color: Colors.white),),
              //  onPressed: validateAndSubmit,
            ),
          ),
        )

    );



  }

  Widget showErrorMessage() {
    if (_errorMessage != null&&_errorMessage.length > 0) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.white,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              Logo(),
              showEmailInput(),
              showPasswordInput(),
              showLoginButton(),
              FogotPassword(),
              showSignupButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  void showEnterEmailDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Wrap(
              children: <Widget>[
               Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(15),
                          right: ScreenUtil().setWidth(15),
                          top: ScreenUtil().setWidth(15)),

                          child:Text(
                            ENTER_EMAIL,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                                textStyle: new TextStyle(
                                  color:Color(0xFF303E84),
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil()
                                      .setSp(16, allowFontScalingSelf: true),
                                )),
                          )),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child:Padding(
                          padding: EdgeInsets.only(top:ScreenUtil().setWidth(10),
                          bottom: ScreenUtil().setWidth(10),
                          right: ScreenUtil().setWidth(40),
                          left: ScreenUtil().setWidth(40)),
                          child: new TextFormField(
                             style: TextStyle(
                               color:  Color(0xFF303E84),
                             ),
                            onChanged: (text) {
                              emailReset= text;
                            },
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            cursorColor:  Color(0xFF303E84),
                            decoration: new InputDecoration(
                                contentPadding:
                                EdgeInsets.all(ScreenUtil().setWidth(0)),
                               hintText: HINT_EMAIL,
                                hintStyle: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: ScreenUtil()
                                          .setSp(14, allowFontScalingSelf: true),
                                      color: Color.fromRGBO(255, 255, 255, 0.4),
                                    )),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF303E84),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF303E84),
                                  ),
                                )),
                            validator: (value) =>
                            value.isEmpty ? EMPTY_EMAIL_ERROR : null,
                            onSaved: (value) => emailReset = value.trim(),
                          )),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child:Padding(
                          padding:  EdgeInsets.all(ScreenUtil().setWidth(10)),
                          child: FlatButton(
                            onPressed: () {
                              if (EmailValidator.validate(emailReset)) {
                                widget.auth.resetPassword(emailReset);
                                Navigator.pop(context, true);
                                showEmailSentDialog();
                                setState(() {
                                  isReset = true;
                                });

                              }else{
                                Fluttertoast.showToast(
                                    msg: NO_USER_ERROR,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 2,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true)
                                );
                              }
                            },
                            child: Text(
                              SEND_RESET_LINK,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil()
                                      .setSp(16, allowFontScalingSelf: true)),
                            ),
                            color: Color(0xFF303E84),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }


  void showEmailSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Wrap(
              children: <Widget>[
               Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topCenter ,
                        child:Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                          child: Text(RESET_LINK_SENT,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                textStyle: new TextStyle(
                                  color: Color(0xFF303E84),
                                  fontSize: ScreenUtil()
                                      .setSp(16, allowFontScalingSelf: true),
                                )),
                          ),
                        )),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding:  EdgeInsets.all(ScreenUtil().setWidth(10)),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    Login(auth: widget.auth,
                                        loginCallback: widget.loginCallback)),
                              );
                            },
                            child: Text(CONTINUE ,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil()
                                      .setSp(16, allowFontScalingSelf: true)),
                            ),
                            color:Color(0xFF303E84),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget showMDG()
  {
    return Align(
      alignment: Alignment.bottomCenter,
    child: Container(
     child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text(
              MADE_WITH,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(14,allowFontScalingSelf: true),
                  color:Colors.white,
                )
              ),
            ),
          ),
          Container(
            child:  new SvgPicture.asset(
              'assets/love.svg',
              allowDrawingOutsideViewBox: true,
            ),
          ),
          Container(
            child: Text(
             BY_MDG,
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(14,allowFontScalingSelf: true),
                    color:Colors.white,
                  )
              ),
            ),
          ),

        ],
     )));
  }

}
