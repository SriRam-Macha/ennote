import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:official_Ennote/services/pdf_upvote.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'add_document.dart';
import 'add_folder.dart';

class ListSort extends StatefulWidget {
  final String path;
  ListSort(this.path);
  @override
  _ListSortState createState() => _ListSortState();
}

class _ListSortState extends State<ListSort> {
  bool loding = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  label: 'Add Folder',
                  child: Icon(MdiIcons.folderPlus),
                  labelStyle: TextStyle(color: Colors.white),
                  labelBackgroundColor: Theme.of(context).accentColor,
                  onTap: () {
                    showDialog(
                      useSafeArea: true,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AddFolder(widget.path);
                      },
                    );
                  },
                ),
                SpeedDialChild(
                  label: "Add File",
                  labelBackgroundColor: Theme.of(context).accentColor,
                  labelStyle: TextStyle(color: Colors.white),
                  child: Icon(MdiIcons.filePlus),
                  onTap: () async {
                    setState(() {
                      loding = !loding;
                    });
                    File file = await FilePicker.getFile(
                        type: FileType.custom, allowedExtensions: ['pdf']);
                    setState(() {
                      loding = !loding;
                    });
                    showDialog(
                      useSafeArea: true,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        if (file == null) {
                          return AlertDialog(
                            actions: [
                              RaisedButton(
                                color: Colors.blueAccent,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Ok"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ],
                            content: ListTile(
                              title: Text("No File Found"),
                            ),
                          );
                        } else {
                          return AddDocument(file, widget.path);
                        }
                      },
                    );
                  },
                ),
                SpeedDialChild(
                    onTap: () async {
                      print(widget.path);
                      var shortcut = await Firestore.instance
                          .collection("Users")
                          .document(user.uid)
                          .updateData({'Current Sub Path': widget.path});
                    },
                    child: Icon(Icons.short_text),
                    label: "Set as Shortcut path",
                    labelStyle: TextStyle(color: Colors.white),
                    labelBackgroundColor: Theme.of(context).accentColor,),
              ],
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  FirebaseAnimatedList(
                    duration: Duration(milliseconds: 500),
                    query: FirebaseDatabase.instance
                        .reference()
                        .child(widget.path)
                        .orderByChild("votes"),
                    itemBuilder: (context, snapshot, animation, index) {
                      if (snapshot.value != 'folder') {
                        if (snapshot.value["doctype"] == 'folder') {
                          return SlideInLeft(
                            duration: Duration(milliseconds: 300),
                            child: Card(
                              elevation: 8.0,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListSort(
                                            widget.path + '/' + snapshot.key),
                                      ),
                                    );
                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 12.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(width: 1.0))),
                                    child: Icon(Icons.folder),
                                  ),
                                  title: Text(
                                    snapshot.key.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text("Folder"),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                ),
                              ),
                            ),
                          );
                        } else if (snapshot.value["doctype"] == 'file') {
                          return SlideInLeft(
                            duration: Duration(milliseconds: 300),
                            child: Card(
                              elevation: 8.0,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PDFView(
                                                  url: snapshot.value["url"],
                                                  name: snapshot.value["name"],
                                                  path: widget.path,
                                                  dockey: snapshot.key,
                                                )));
                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 12.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(width: 1.0))),
                                    child: Icon(Icons.picture_as_pdf),
                                  ),
                                  title: Text(
                                    snapshot.value["name"].toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(snapshot.value["votes"]
                                      .toString()
                                      .substring(1)),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                  loding
                      ? Positioned(
                          child: Center(child: CircularProgressIndicator()))
                      : SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
