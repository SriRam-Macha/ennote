import 'package:firebase_storage/firebase_storage.dart';
import 'dart:collection';

class Storage {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future getList() async {
    StorageReference reference =
        _storage.ref().child("Semesters/1Semester/DedicatedNotes");
    var list = LinkedHashMap<dynamic, dynamic>();
    list = await reference.listAll();
    LinkedHashMap<dynamic, dynamic> path = list["items"];
    var name = List<NameDoc>();
    path.entries.forEach((e) async {
      name.add(NameDoc(e.value["name"], e.value["path"]));
    });

    return null;
  }

  getdownloadurl(dynamic path) async {
    var url = await _storage.ref().child("$path").getDownloadURL();
    return url;
  }

  Future<List> getitems(String docpath) async {
    print("object");
    StorageReference reference = _storage.ref().child(docpath);
    var list = LinkedHashMap<dynamic, dynamic>();
    list = await reference.listAll();
    LinkedHashMap<dynamic, dynamic> doc = list["items"];
    LinkedHashMap<dynamic, dynamic> folder = list["prefixes"];
    List docname = List();
    List foldername = List();
    doc.entries.forEach((e) {
      docname.add(NameDoc(e.value["name"], e.value["path"]));
    });

    folder.entries.forEach((e) {
      foldername.add(NameFolder(e.value["name"], e.value["path"]));
    });

    print([docname,foldername]);
    return [docname,foldername];
  }
}

class NameDoc {
  dynamic name;
  dynamic path;
  NameDoc(
    this.name,
    this.path,
  );

  @override
  String toString() {
    return '{ ${this.name}, ${this.path}, }';
  }
}

class NameFolder {
  dynamic name;
  dynamic path;
  NameFolder(
    this.name,
    this.path,
  );

  @override
  String toString() {
    return '{ ${this.name}, ${this.path}, }';
  }
}
