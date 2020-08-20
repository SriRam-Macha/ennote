
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:official_Ennote/services/auth.dart';

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
        backgroundColor: Color(0xffBBDEFA),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipPath(
                    clipper: new MyClipper(),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      color: Colors.white,
                      child: Container(
                        height: height / 2,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: height / 4),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 0.0, 8.0, 8.0),
                                child: TextFormField(
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'Please enter a valid SRM  E-mail';
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => _email = input.trim(),
                                  decoration: InputDecoration(
                                      labelText: 'Email',
                                      suffixIcon: Tooltip(
                                          message:
                                              'Only SRM mail id\'s are allowed',
                                          child: Icon(Icons.help_outline))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 8.0, 8.0, 0.0),
                                child: TextFormField(
                                  validator: (input) {
                                    if (input.length < 6) {
                                      return 'Please provide a vaild password';
                                    }
                                    return null;
                                  },
                                  onSaved: (input) => _password = input,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height * 0.703 - posheight / 2,
                left: width / 2 - 50,
                child: ButtonTheme(
                    minWidth: 100,
                    height: 30,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _auth.signInwithEmailandPassword(
                              _email, _password, _scafoldkey);
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      child: Text(
                        "Log In",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
              Positioned(
                top: height / 20 * 5.75 - posheight / 2,
                left: width / 2 - 50,
                child: CircleAvatar(
                  child: Icon(
                    MdiIcons.account,
                    color: Colors.amberAccent,
                  ),
                  radius: 40.0,
                ),
              ),
              Positioned(
                top: height * 16 / 20 - posheight / 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: InkWell(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Text("Sign Up",
                            style: TextStyle(fontSize: 20, color: Colors.blue)),
                      ),
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
              )
            ],
          ),
        ));
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
