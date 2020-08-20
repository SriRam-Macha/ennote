import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'storage.dart';

class Webpage extends StatefulWidget {
  final dynamic url;
  Webpage(this.url);
  @override
  _WebpageState createState() => _WebpageState();
}

class _WebpageState extends State<Webpage> {
  WebViewController controller;
  final Storage _storage = Storage();
  String url;
  num count;
  bool reload = true;
  WebViewController _myController;
  Future webview;
  @override
  void initState() {
    webview = _loadweb();
    super.initState();
  }

  _loadweb() async {
    return await _storage.getdownloadurl(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(future: webview.then((value) {
          url = Uri.encodeComponent("$value");
          print(url);
        }), builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: <Widget>[
                WebView(
                  gestureNavigationEnabled: true,
                  gestureRecognizers: [
                    Factory(() => EagerGestureRecognizer()),
                  ].toSet(),
                  userAgent:
                      "Mozilla/5.0 (X11; CrOS x86_64 8172.45.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.64 Safari/537.36",
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl:
                      "https://docs.google.com/gview?embedded=true&url=$url",
                  onPageFinished: (initialUrl) {
                    _myController.evaluateJavascript(
                        "document.getElementById('toolbar').style.display = 'none';");
                  },
                ),
                Container(
                  child: ListTile(
                    trailing: FlatButton.icon(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        setState(() {});
                      },
                      label: Text("Reload"),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height /
                      ((MediaQuery.of(context).orientation.index.isEven)
                          ? 14
                          : 7),
                  color: Colors.blueAccent,
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}
