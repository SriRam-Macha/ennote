import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService{
  
  final String uid;
  DataBaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('Users');
  

  Future updateUserData({String name = '', String clearenceLevel = '', String subPath = ''})async{
    return await userCollection.document(uid).setData({
      'Name' : name,
      'clearance Level' : clearenceLevel,
      'Current Sub Path': subPath,
      'UpvotedDoc': []
    });
  }
}