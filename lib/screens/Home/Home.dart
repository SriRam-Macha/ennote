import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:official_Ennote/services/auth.dart';
import 'package:official_Ennote/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'Listupvote.dart';
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
    final shortcut = Provider.of<DocumentSnapshot>(context);
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
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
            drawer: AppDrawer(),
            body: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    ListTile(title: Text('Semester\'s Page'),trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Semisters()));
                    },),
                    ListTile(
                      onTap: () {
                        if (shortcut["Current Sub Path"]
                            .toString()
                            .isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ListSort(shortcut["Current Sub Path"]),
                            ),
                          );
                        } else {
                          _globalKey.currentState.showSnackBar(SnackBar(
                              content: Text("There are no Shortcuts added")));
                        }
                      },
                      
                      title: Text("Your Subjects shortcut"),focusColor: Theme.of(context).accentColor,
                      trailing: Icon(Icons.arrow_forward),
                    ),
                    
                    
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
