import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDocument extends StatefulWidget {
  final File document;
  final String doc_path;
  AddDocument(this.document, this.doc_path);
  @override
  _AddDocumentState createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  StorageUploadTask _uploadTask;
  double val = 0;
  String _url;
  String _doc_name = '';
  String _uploder_name = 'Anonymous';
  bool loading = false;
  bool oncomplete = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return AlertDialog(
      title: Text("Enter Details"),
      actions: [
        RaisedButton(
          color: Colors.blueAccent,
          onPressed: () {
            if (_uploadTask != null) {
              _uploadTask.cancel();
            }
            Navigator.pop(context);
          },
          child: Text("Cancel"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        RaisedButton(
          color: Colors.blueAccent,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              StorageReference reference =
                  FirebaseStorage.instance.ref().child(_doc_name);
              StorageUploadTask uploadTask =
                  reference.putData(widget.document.readAsBytesSync());
              uploadTask.events.listen((event) {
                setState(() {
                  loading = true;
                  val = 100 *
                      (event.snapshot.bytesTransferred.toDouble() /
                          event.snapshot.totalByteCount.toDouble());
                });
              }).onError((error) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(error.toString()),
                    );
                  },
                );
              });

              await uploadTask.onComplete
                  .then((values) => values.ref.getDownloadURL().then((value) {
                        setState(() {
                          _url = value.toString();
                        });
                      }));

              print(_url);

              if (_url.isNotEmpty) {
                DatabaseReference databaseReference =
                    FirebaseDatabase.instance.reference().child("Moderater"); 

                databaseReference.push().set({
                  'name': _doc_name,
                  'doctype': 'file',
                  'url': _url,
                  'uploder_data': _uploder_name,
                  'path': widget.doc_path,
                  'uid': user.uid
                }).whenComplete(() {
                  setState(() {
                    oncomplete = true;
                    loading = false;
                  });
                });
              }
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
              maxLength: 50,
              onSaved: (newValue) => _doc_name = newValue,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Document Name cannot be empty';
                }
                return null;
              },
              decoration: InputDecoration(labelText: "Document Name"),
            ),
            TextFormField(
              validator: (value) {
                if (value.length < 3 && value.isNotEmpty) {
                  return 'Should be empty or more than 3 charecters';
                }
                return null;
              },
              decoration: InputDecoration(
                  helperText: 'Keep empty for Anonymous',
                  labelText: "Uplodeer's Name"),
            ),
            loading
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 48, 0.0, 16),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(val.toString() + '%'),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: val.roundToDouble(), 
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            oncomplete
                ? Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                        "Your File Has been Uploded \nPlease wait for the Moderator to accept the document."),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
