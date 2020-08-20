import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFolder extends StatefulWidget {
  final String docpath;
  AddFolder(this.docpath);
  @override
  _AddFolderState createState() => _AddFolderState();
}

class _AddFolderState extends State<AddFolder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _docname;
  bool oncomplete = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return AlertDialog(
      actions: [
        RaisedButton(
          color: Colors.blueAccent,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              DatabaseReference databaseReference =
                  FirebaseDatabase.instance.reference().child("Moderater");
              databaseReference.push().set({
                'name': _docname,
                'doctype': 'folder',
                'path': widget.docpath,
                'uid': user.uid
              }).whenComplete(() {
                setState(() {
                  oncomplete = true;
                });
              });
            }
          },
          child: Text("Submit"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        oncomplete
            ? RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Agree"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              )
            : SizedBox.shrink(),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              onSaved: (newValue) {
                _docname = newValue;
              },
              validator: (value) {
                if (value.length < 3) {
                  return 'Length cannot be less than';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Folder Name'),
            ),
            oncomplete
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Your Folder request has been initiated. Please wait our moderator will act as soon as possible"),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
