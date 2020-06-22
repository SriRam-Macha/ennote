import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService{
  
  final String uid;
  DataBaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('Users');
  

  Future updateUserData({String name = 'No User Name', String clearenceLevel = 'Zero', String subPath = 'Not declared'})async{
    return await userCollection.document(uid).setData({
      'Name' : name,
      'clearance Level' : clearenceLevel,
      'Current Sub Path': subPath
    });
  }
}