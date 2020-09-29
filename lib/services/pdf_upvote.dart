import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:provider/provider.dart';
// import 'storage.dart';

class PDFView extends StatefulWidget {
  final String dockey;
  final String path;
  final String url;
  final String name;
  PDFView({this.dockey, this.url, this.name, this.path});
  @override
  _PDFViewState createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  // final Storage _storage = Storage();
  PdfController _pdfController;
  Future docbytes;
  Uint8List bytes;
  double val = 1;
  double maximumval = 1;
  double cumulativedata = 0;
  bool largefile = false;

  @override
  void initState() {
    docbytes = _getdocbytes(widget.url);
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  _getdocbytes(String path) async {
    String url = path;
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(
      response,
      onBytesReceived: (cumulative, total) {
        if (total > 2000000) {
          setState(() {
            largefile = true;
          });
        }
        setState(() {
          cumulativedata = cumulative / total;
        });
      },
    );
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(
            fontSize: 15,
          ),
          overflow: TextOverflow.fade,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              _pdfController.previousPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "${val.toInt()} / ${maximumval.toInt()}",
              style: TextStyle(fontSize: 22),
            ),
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              _pdfController.nextPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuEntry<Row>>[
                PopupMenuItem(
                  enabled: false,
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("Users")
                        .document(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      print(widget.url);
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        if (snapshot.data["UpvotedDoc"].contains(widget.url)) {
                          return IconButton(
                            color: Colors.red,
                            icon: Icon(MdiIcons.thumbUp),
                            onPressed: () {
                              Firestore.instance
                                  .collection("Users")
                                  .document(user.uid)
                                  .updateData({
                                "UpvotedDoc":
                                    FieldValue.arrayRemove([widget.url])
                              });

                              final dataRef = FirebaseDatabase.instance
                                  .reference()
                                  .child(widget.path + '/' + widget.dockey);
                              dataRef.runTransaction(
                                  (MutableData transaction) async {
                                print(transaction.value.toString() + "hello");
                                transaction.value['votes'] =
                                    (transaction.value['votes'] ?? 0) + 1;
                                return transaction;
                              });
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          return IconButton(
                            icon: Icon(MdiIcons.thumbUpOutline),
                            onPressed: () {
                              Firestore.instance
                                  .collection("Users")
                                  .document(user.uid)
                                  .updateData({
                                "UpvotedDoc":
                                    FieldValue.arrayUnion([widget.url])
                              });

                              final dataRef = FirebaseDatabase.instance
                                  .reference()
                                  .child(widget.path + '/' + widget.dockey);
                              dataRef.runTransaction(
                                  (MutableData transaction) async {
                                print(transaction.value.toString() + "hello");
                                transaction.value['votes'] =
                                    (transaction.value['votes'] ?? 0) - 1;
                                return transaction;
                              });
                              Navigator.pop(context);
                            },
                            color: Colors.black,
                          );
                        }
                      }
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 25,
            child: FutureBuilder(
              future: docbytes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_pdfController == null) {
                    _pdfController = PdfController(
                      document: PdfDocument.openData(snapshot.data),
                    );
                  }
                  return PdfView(
                    pageSnapping: false,
                    scrollDirection: Axis.vertical,
                    documentLoader: Center(child: CircularProgressIndicator()),
                    pageLoader: Center(child: CircularProgressIndicator()),
                    controller: _pdfController,
                    onDocumentLoaded: (document) {
                      setState(
                        () {
                          maximumval = _pdfController.pagesCount.toDouble();
                        },
                      );
                    },
                    onPageChanged: (page) {
                      setState(
                        () {
                          val = page.toDouble();
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          largefile
                              ? Text(
                                  "This is a large Document please wait while \nthe document loads....",
                                  textAlign: TextAlign.center,
                                )
                              : Text("Loading...."),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    (cumulativedata * 100).toInt().toString() +
                                        " %"),
                              ),
                              Expanded(
                                child: LinearProgressIndicator(
                                  minHeight: 6.0,
                                  value: cumulativedata,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Slider(
            label: val.toInt().toString(),
            value: val,
            divisions:
                (maximumval.toInt() - 1) == 0 ? null : maximumval.toInt() - 1,
            onChanged: (value) {
              setState(
                () {
                  val = value;
                  _pdfController.animateToPage(value.toInt(),
                      duration: Duration(milliseconds: 75), curve: Curves.ease);
                },
              );
            },
            min: 1,
            max: maximumval,
          ),
        ],
      ),
    );
  }
}

// onDocumentLoaded: (document) {
//                   setState(() {
//                     _allPagesCount = document.pagesCount;
//                   });
//                 },
//                 onPageChanged: (page) {
//                   setState(() {
//                     _actualPageNumber = page;
//                   });
//                 },
