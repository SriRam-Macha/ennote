import 'package:ennot_test/services/auth.dart';
import 'package:flutter/material.dart';

class Inforeg extends StatefulWidget {
  @override
  _InforegState createState() => _InforegState();
}

class _InforegState extends State<Inforeg> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _sempath;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
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
                if (value.isEmpty) { 
                  return 'Please provide a vaild password';
                }
                return null;
              },
              onSaved: (newValue) => _sempath = newValue,
            ),
            RaisedButton(
              onPressed: () {
                if(_formKey.currentState.validate()){
                  _formKey.currentState.save();
                  print(_sempath);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class SemisterList {
  final String semister;
  final String semPath;

  SemisterList(this.semister, this.semPath);
}
