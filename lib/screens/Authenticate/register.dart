import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:official_Ennote/services/auth.dart';
import '../../uidata.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _email, _password, _passwordConfirm;
  bool _showPassword = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double posheight = 0.0;

    setState(() {
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        posheight = (MediaQuery.of(context).viewInsets.bottom);
      }
    });

    return Scaffold(
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
                    "Sign up to continue",
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
                          keyboardType: TextInputType.emailAddress,
                          validator: (input) {
                            if (input.isEmpty ||
                                !input.endsWith('@srmap.edu.in')) {
                              return 'Please enter a valid SRM  E-mail';
                            } else {
                              return null;
                            }
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
                          controller: _pass,
                          validator: (val) {
                            if (val.length < 6) {
                              return 'Please provide a vaild password';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (val) => _password = val,
                          decoration: InputDecoration(
                              labelText: 'Password',
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
                          obscureText: !_showPassword,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 30.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          controller: _confirmpass,
                          validator: (inpute) {
                            if (inpute != _pass.text) {
                              return 'Please provide a vaild password';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (inpute) => _passwordConfirm = inpute,
                          decoration: InputDecoration(
                              labelText: 'Confirm Password',
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
                          obscureText: !_showPassword,
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
                            "SIGN UP",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _auth.registerwithEmailandPassword(
                                  _email, _passwordConfirm, _scaffold);
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
