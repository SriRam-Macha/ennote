import 'package:ennot_test/screens/Authenticate/Forgetpassword.dart';
import 'package:ennot_test/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: Auth().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ennote',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Wrapper(),
      ),
    );
  }

}
