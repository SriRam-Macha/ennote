import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'database.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> signInwithEmailandPassword(
      String email, String password, GlobalKey<ScaffoldState> key,
      {color}) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (!result.user.isEmailVerified)
        showInSnackBar("Email not Verified", key,
            color: Colors.deepOrangeAccent);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      if (e is PlatformException) {
        showInSnackBar("${e.message}", key, color: Colors.red);
      }
      return null;
    }
  }

  Future<FirebaseUser> registerwithEmailandPassword(
      String email, String password, GlobalKey<ScaffoldState> key,
      {color}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user != null)
        showInSnackBar("User Registered", key, color: Colors.green);
      user.sendEmailVerification();
      await DataBaseService(uid: user.uid).updateUserData();
      return user;
    } catch (e) {
      if (e is PlatformException) {
        showInSnackBar("${e.message}", key, color: Colors.red);
      }
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future resetPassword(
    String email,
    GlobalKey<ScaffoldState> key,
  ) async {
    try {
      await _auth.sendPasswordResetEmail(email: '$email');
      showInSnackBar("Password Reset E-mail has been sent to\n$email", key,
          color: Colors.green);
      return null;
    } catch (e) {
      if (e is PlatformException) {
        showInSnackBar("${e.message}", key, color: Colors.red);
      }
      return null;
    }
  }

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Future currentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user;
  }

  showInSnackBar(String value, GlobalKey<ScaffoldState> key, {Color color}) {
    key.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(value)));
  }
}
