import 'package:ennot_test/services/auth.dart';
import 'package:flutter/material.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  String _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scafoldkey = GlobalKey<ScaffoldState>();
  final Auth _auth = Auth();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scafoldkey,
      backgroundColor: Color(0xffBBDEFA),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: height / 7,
              child: Card(
                color: Colors.white,
                child: Container(
                  height: height / 3.5,
                  width: width * 18 / 20,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Pls Enter Your Registered E-mail",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600 
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            validator: (input) {
                              if (input.isEmpty ||
                                  !input.endsWith('@srmap.edu.in')) {
                                return 'Please enter a valid SRM  E-mail';
                              }
                              return null;
                            },
                            onSaved: (input) => _email = input.trim(),
                            decoration: InputDecoration(
                                labelText: 'Email',
                                suffixIcon: Tooltip(
                                    message: 'Only SRM mail id\'s are allowed',
                                    child: Icon(Icons.help_outline))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: height / 2,
              child: RaisedButton(
                color: Colors.green,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _auth.resetPassword('$_email', _scafoldkey);
                  }
                },
                child: Text("Send Reset Password E-mail"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
