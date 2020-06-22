import 'dart:io';

import 'package:ennot_test/services/pdfview.dart';
import 'package:ennot_test/services/storage.dart';
import 'package:ennot_test/services/web_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ItemList extends StatefulWidget {
  final String docpath;
  ItemList(this.docpath);
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final Storage _storage = Storage();
  List<dynamic> doclist = List<dynamic>();
  List<dynamic> folderlist = List<dynamic>();
  String docpath;
  String folderpath;
  bool folderdocdirection = true;
  bool docdirection = true;
  bool setstate = true;
  Future storagedoc;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    docpath = widget.docpath;
    storagedoc = _getdoc();
  }

  _getdoc() async {
    return await _storage.getitems(docpath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        verticalDirection:
            folderdocdirection ? VerticalDirection.down : VerticalDirection.up,
        children: <Widget>[
          folderdocdirection
              ? Expanded(
                  flex: 1,
                  child: FutureBuilder(future: storagedoc.then((value) {
                    folderlist = value[1];
                    if (folderlist.isEmpty) {
                      setState(() {
                        folderdocdirection = false;
                      });
                    } else if (value[0].isEmpty && setstate) {
                      setState(() {
                        docdirection = false;
                        setstate = false;
                      });
                    }
                  }), builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text("Folders",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 15,
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemCount: folderlist.length,
                                padding: EdgeInsets.all(16.0),
                                itemBuilder: (context, index) {
                                  return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      elevation: 15,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ItemList(folderlist[index]
                                                          .path)));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Container(
                                            child: Center(
                                              child:
                                                  Text(folderlist[index].name),
                                            ),
                                          ),
                                        ),
                                      ));
                                }),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
                )
              : SizedBox.shrink(),
          docdirection
              ? Expanded(
                  flex: 2,
                  child: FutureBuilder(future: storagedoc.then((value) {
                    doclist = value[0];
                  }), builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Text(
                                "Files",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Expanded(
                            flex: 15,
                            child: ListView.builder(
                                itemCount: doclist.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      if ((doclist[index].path)
                                          .toString()
                                          .endsWith('pdf')) {
                                        // String url =
                                        //     await _storage.getdownloadurl(
                                        //         doclist[index].path);
                                        // var request = await HttpClient()
                                        //     .getUrl(Uri.parse(url));
                                        // var response = await request.close();
                                        // var bytes =
                                        //     await consolidateHttpClientResponseBytes(
                                        //         response);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PDFView(
                                                    path:
                                                        doclist[index].path)));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Webpage(
                                                    doclist[index].path)));
                                      }
                                    },
                                    child: Card(
                                      elevation: 8.0,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 6.0),
                                      child: Container(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10.0),
                                          leading: Container(
                                            padding:
                                                EdgeInsets.only(right: 12.0),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        width: 1.0))),
                                            child: Icon(MdiIcons.filePdf),
                                          ),
                                          title: Text(
                                            doclist[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(docpath),
                                          trailing:
                                              Icon(Icons.keyboard_arrow_right),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: SizedBox.shrink());
                    }
                  }),
                )
              : SizedBox.shrink()
        ],
      ),
    ));
  }
}
