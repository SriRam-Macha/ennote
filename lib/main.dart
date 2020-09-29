import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'constants.dart';
import 'screens/wrapper.dart';
import 'screens/Home/profile_screen.dart';
import 'services/auth.dart';

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
      child: ThemeProvider(
        initTheme: kDarkTheme,
        child: Builder(
          builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Ennote',
              theme: ThemeProvider.of(context),
              home: Wrapper(),
              routes: {
                ProfileScreen.routeName : (ctx) => ProfileScreen(),              },
            );
          },
        ),
      ),
    );
  }
}
