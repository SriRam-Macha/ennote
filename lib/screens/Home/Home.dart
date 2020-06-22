import 'package:ennot_test/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sem_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final Auth _auth = Auth();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
              },
              label: Text("Log Out"),
            )
          ],
          title: Text("Home"),
        ),
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  color: Colors.red,
                  onPressed: () async {
                    await _auth.signOut();
                  },
                ),
                RaisedButton(
                  child: Text("Press the grey button below"),
                  onPressed: () {
                    if("".isNotEmpty){
                      print("empty");
                    }
                  },
                  color: Colors.green,
                ),
                RaisedButton(onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Semisters()));
                }),
                RaisedButton(
                  onPressed: () async {
                    await _auth.resetPassword('mssr001@gmail.com', _globalKey);
                  },
                  color: Colors.blue,
                ),
                RaisedButton(onPressed: () async {
                  UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
                  userUpdateInfo.displayName = "Sri Ram";
                  await user.updateProfile(userUpdateInfo);
                })
              ],
            ),
          ),
        ));
  }
}
