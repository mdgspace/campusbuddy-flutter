import 'package:campusbuddy/globals.dart';
import 'package:campusbuddy/root_page.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.auth, this.loginCallback}) : super(key: key);

  final Auth auth;
  final VoidCallback loginCallback;

  @override
  _SignupPageState createState() => new _SignupPageState();
}


class _SignupPageState extends State<SignupPage> {

  final _formKeySignup = new GlobalKey<FormState>();
  bool _isLoading=false;
  String _errorMessage='';
  String _email='';
  String _password='';
  String passwordLengthError='';
  String invalidEmailError='';
  String gsuiteEmailError='';


  bool validateAndSave() {
    final form = _formKeySignup.currentState;
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
        userId = await widget.auth.signUp(_email, _password);
        print('Signed up user: $userId');


        setState(() {
          _isLoading = false;
        });

        if (userId != null && userId.length > 0) {
         // widget.loginCallback();
         showDialogBox();
        }
      } catch (e) {
        print('Error: $e');
        Fluttertoast.showToast(
            msg:  e.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true)
        );
        setState(() {
          _isLoading = false;
          _formKeySignup.currentState.reset();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 410, height: 703, allowFontScaling: true);

    return Scaffold(
        body: Container(
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
    );
  }

  Widget _showForm() {
    return new Container(
        //padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKeySignup,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
               Logo(),
              showEmailInput(),
              showInvalidEmailError(),
              showPasswordInput(),
              showPasswordLengthError(),
              showSignUpButton(),
              showLoginButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0.0),
      child: new TextFormField(
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
        ),
        onChanged: (text) {
          _email = text;
        },
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
          ),),
        validator: (value) => value.isEmpty ? EMPTY_EMAIL_ERROR : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
      child: new TextFormField(
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
        ),
        onChanged: (text) {
          _password = text;
        },
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
      ),),
        validator: (value) => value.isEmpty ? EMPTY_PASSWORD_ERROR : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPasswordLengthError() {
    if (passwordLengthError.length > 0 && passwordLengthError != "") {
      return new Container(
          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(75), ScreenUtil().setWidth(10), ScreenUtil().setWidth(30), 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${passwordLengthError}',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                  color: Colors.red,
                  height: ScreenUtil().setHeight(1),
                  fontWeight: FontWeight.w300),
            ),
          ));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showInvalidEmailError() {
    if (invalidEmailError.length > 0 && invalidEmailError != "") {
      return new Container(
          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(75), ScreenUtil().setWidth(10), ScreenUtil().setWidth(30), 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${invalidEmailError}',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                  color: Colors.red,
                  height: ScreenUtil().setHeight(1),
                  fontWeight: FontWeight.w300),
            ),
          ));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }


  Widget showSignUpButton() {
//    bool val=_email!="";
//    print('val is ${val}');
   return new Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(120),
            right: ScreenUtil().setWidth(120),
            top: ScreenUtil().setWidth(45),
            bottom: ScreenUtil().setWidth(70)),
        child: SizedBox(
          //height: 45.0,
            child: new FlatButton(
               //onPressed: validateAndSubmit,
               onPressed: ()
              {
                setState(() {
                  passwordLengthError='';
                  invalidEmailError='';
                  gsuiteEmailError='';
                });

                if(EmailValidator.validate(_email))
                  {
                    if(_email.contains('iitr.ac.in'))
                      {
                        if(_password.length>=6)
                        {
                          validateAndSubmit();
                        }
                        else
                        {
                          setState(() {
                            passwordLengthError=UNACCEPTABLE_PASSWORD;
                            invalidEmailError='';

                          });
                        }
                      }
                    else
                      {
                         setState(() {
                          invalidEmailError=GSUITE_ERROR;
                           if(_password.length<6)
                             {
                               passwordLengthError=UNACCEPTABLE_PASSWORD;
                             }
                         });
                      }
                  }
                else
                  {
                    setState(() {
                      invalidEmailError=UNACCEPTABLE_EMAIL;
                      if(_password.length<6)
                      {
                        passwordLengthError=UNACCEPTABLE_PASSWORD;
                      }
                    });
                  }

              },

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
                child: new Text(SIGN_UP,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(22, allowFontScalingSelf: true),
                        fontWeight: FontWeight.w500,
                        color: Colors.white),),
                ),
              ),
            ))
    );

  }

  Widget showErrorMessage() {
    if (_errorMessage != null &&_errorMessage.length > 0) {
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

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }


  Widget showLoginButton() {
    return new Container(
        margin: EdgeInsets.only(left: ScreenUtil().setWidth(120),
            right: ScreenUtil().setWidth(120),
            top: ScreenUtil().setWidth(45),
            bottom: ScreenUtil().setWidth(70)),
        child: SizedBox(
          //height: 45.0,
            child: new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
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
                child: new Text('Login',
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
          margin:EdgeInsets.only(left: ScreenUtil().setWidth(130),right: ScreenUtil().setWidth(145)) ,
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


  Widget showDialogBox()
  {
    showDialog(context: context,
    builder: (BuildContext context)
    {
      return Dialog(
        child: Wrap(
          children: <Widget>[
           Column(
             mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(40),
                      top: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setWidth(20)),
                  child: Text(
                      SIGNUP_SUCCESSFUL,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      color: Color(0xFF303E84),
                    )
                  ),
                  ),
                ),
                FlatButton(
                  onPressed: ()
                  {
                    Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) =>Login(auth: widget.auth,
                      loginCallback: widget.loginCallback,)));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(40),
                    bottom:ScreenUtil().setWidth(20) ),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                    color: Color(0xFF303E84),
                    child: Text(CONTINUE,
                    style: TextStyle(
                        color: Colors.white,
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto'
                    ),),
                  ),
                )
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