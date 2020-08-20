import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Authenticate/Authenticate.dart';
import 'Home/Home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    if (user == null) {
      return Authenticate();
    } else {
      if (user.isEmailVerified) {
        return StreamProvider<DocumentSnapshot>.value(
            value: Firestore.instance
                .collection("Users")
                .document(user.uid)
                .snapshots(),
            child: WrapperHome());
      } else {
        return Authenticate();
      }
    }
  }
}

class WrapperHome extends StatefulWidget {
  @override
  _WrapperHomeState createState() => _WrapperHomeState();
}

class _WrapperHomeState extends State<WrapperHome> {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
