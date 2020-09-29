import 'package:flutter/material.dart';
import '../screens/Home/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(),
          Divider(),
          ListTile(
              title: Text('My Profile'),
              onTap: () =>
                  Navigator.of(context).pushNamed(ProfileScreen.routeName))
        ],
      ),
    );
  }
}
