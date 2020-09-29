import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:official_Ennote/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

class Inforeg extends StatefulWidget {
  @override
  _InforegState createState() => _InforegState();
}

class _InforegState extends State<Inforeg> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Auth _auth = Auth();
  String _sempath, _branch;
  List<SemisterList> semister = [
    SemisterList("Semister 1", "Semesters/1Semester"),
    SemisterList("Semister 2", "Semesters/2Semester"),
    SemisterList("Semister 3", "Semesters/3Semester"),
    SemisterList("Semister 4", "Semesters/4Semester"),
    SemisterList("Semister 5", "Semesters/5Semester"),
    SemisterList("Semister 6", "Semesters/6Semester"),
    SemisterList("Semister 7", "Semesters/7Semester"),
    SemisterList("Semister 8", "Semesters/8Semester")
  ];
  Future<QuerySnapshot> brachesfunc;
  List branches;

  @override
  void initState() {
    super.initState();
    brachesfunc = _getBranches();
  }

  Future<QuerySnapshot> _getBranches() async {
    return await Firestore.instance.collection("Branches").getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
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
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      items: semister.map((e) {
                        return DropdownMenuItem(
                          value: e.semPath,
                          child: Text(e.semister),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _sempath = value);
                      },
                      value: _sempath,
                      hint: Text("Select semister"),
                      validator: (String value) {
                        if (value == null) {
                          return 'Please provide a vaild password';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _sempath = newValue,
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection("Branches")
                          .document("zLHFB0zTNnkt76co1azM")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List branches = snapshot.data["Branches"];
                          return DropdownButtonFormField(
                            items: branches.map((e) {
                              return DropdownMenuItem(
                                value: e.toString(),
                                child: Text("$e"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _branch = value;
                              });
                            },
                            value: _branch,
                            hint: Text("Select Branch"),
                            validator: (String value) {
                              if (value == null) {
                                return 'Please provide a vaild password';
                              }
                              return null;
                            },
                            onSaved: (newValue) => _branch = newValue,
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Firestore.instance
                                .collection("Users")
                                .document(user.uid)
                                .updateData({
                              "Current Sub Path": "${_sempath + "/" + _branch}"
                            });
                            print(_sempath + "/" + _branch);
                          }
                        },
                      ),
                    )
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

class SemisterList {
  final String semister;
  final String semPath;

  SemisterList(this.semister, this.semPath);
}
