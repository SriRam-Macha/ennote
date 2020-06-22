import 'package:flutter/material.dart';

import 'Listpage.dart';

class Semisters extends StatefulWidget {
  @override
  _SemistersState createState() => _SemistersState();
}

class _SemistersState extends State<Semisters> {
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
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Color(0xff3B4254),
        body: SafeArea(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18),
                itemCount: semister.length,
                padding: EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  return Card(
                      color: Color(0xff545D6E),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      elevation: 15,
                      child: InkWell(
                        onTap: (){Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ItemList(semister[index].semPath)));},
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Container(
                            child: Text(semister[index].semister),
                          ),
                        ),
                      ));
                })),
      ),
    );
  }
}

class SemisterList {
  final String semister;
  final String semPath;

  SemisterList(this.semister, this.semPath);
}
