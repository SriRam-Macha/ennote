import 'package:ennot_test/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
        key: _scaffold,
        backgroundColor: Color(0xffBBDEFA),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ClipPath(
                    clipper: new MyClipper(),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      color: Colors.white,
                      child: Container(
                        height: height / 2,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: height / 5),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 0.0, 8.0, 8.0),
                                child: TextFormField(
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 8.0, 8.0, 0.0),
                                child: TextFormField(
                                  controller: _confirmpass,
                                  validator: (inpute) {
                                    if (inpute != _pass.text) {
                                      return 'Please provide a vaild password';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (inpute) =>
                                      _passwordConfirm = inpute,
                                  decoration: InputDecoration(
                                      labelText: 'Confirm Password',
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _auth.registerwithEmailandPassword(
                              _email, _passwordConfirm, _scaffold);
                        }
                      }),
                ),
              ),
              Positioned(
                top: height / 20 * 5.25 - posheight / 2,
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
                  left: width / 2 - 30,
                  child: InkWell(
                      onTap: () {
                        widget.toggleView();
                      },
                      child: Text("Log In",
                          style: TextStyle(fontSize: 20, color: Colors.blue))))
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
