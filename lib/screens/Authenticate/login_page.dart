import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:official_Ennote/services/auth.dart';
import '../../uidata.dart';

import 'Forgetpassword.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;
  LoginPage({this.toggleView});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  bool _showPassword = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).size.height / 20;
    double posheight = 0.0;

    setState(() {
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        posheight = (MediaQuery.of(context).viewInsets.bottom);
      }
    });

    return Scaffold(
      key: _scafoldkey,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlutterLogo(
                    colors: Colors.green,
                    size: 80.0,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Welcome to ${UIData.appName}",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.green),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Sign in to continue",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please enter a valid SRM  E-mail';
                            }
                            return null;
                          },
                          onSaved: (input) => _email = input.trim(),
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.black),
                              suffixIcon: Tooltip(
                                  message: 'Only SRM mail id\'s are allowed',
                                  child: Icon(Icons.help_outline))),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 30.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          maxLines: 1,
                          validator: (input) {
                            if (input.length < 6) {
                              return 'Please provide a vaild password';
                            }
                            return null;
                          },
                          onSaved: (input) => _password = input,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Enter your password",
                              hintStyle: TextStyle(color: Colors.black),
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.black),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                                child: Icon(_showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 30.0),
                        width: double.infinity,
                        child: RaisedButton(
                          padding: EdgeInsets.all(12.0),
                          shape: StadiumBorder(),
                          child: Text(
                            "SIGN IN",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _auth.signInwithEmailandPassword(
                                  _email, _password, _scafoldkey);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      InkWell(
                        child: Text(
                          "SIGN UP FOR AN ACCOUNT",
                          style: TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          widget.toggleView();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 30.0),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PasswordReset()));
                        },
                        child: Text("Forgot Password",
                            style: TextStyle(fontSize: 20, color: Colors.blue)),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(0.0, size.height / 2.5);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
