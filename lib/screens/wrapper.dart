import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Authenticate/Authenticate.dart';
import 'Home/Home.dart';
import 'Home/userinforeg.dart';

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
        return StreamBuilder(
          stream: Firestore.instance
              .collection('Users')
              .document(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            DocumentSnapshot userinfo = snapshot.data;
            if (userinfo["Current Sub Path"].toString().isEmpty) {
              return Inforeg();
            } else {
              return Home();
            }
          },
        );
      } else {
        return Authenticate();
      }
    }
  }
}
