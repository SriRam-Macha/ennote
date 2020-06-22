import 'dart:io';
import 'dart:typed_data';

import 'package:ennot_test/services/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PDFView extends StatefulWidget {
  final String path;
  PDFView({this.path});
  @override
  _PDFViewState createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  final Storage _storage = Storage();
  PdfController _pdfController;
  Future docbytes;
  Uint8List bytes;

  @override
  void initState() {
    docbytes = _getdocbytes(widget.path);
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  _getdocbytes(String path) async {
    String url = await _storage.getdownloadurl(path);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PDF'),
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
                'Previous / Next',
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
          ],
        ),
        body: FutureBuilder(
          future: docbytes.then((value) {
            _pdfController = PdfController(
              document: PdfDocument.openData(value),
            );
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return PdfView(
                scrollDirection: Axis.vertical,
                documentLoader: Center(child: CircularProgressIndicator()),
                pageLoader: Center(child: CircularProgressIndicator()),
                controller: _pdfController,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
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
