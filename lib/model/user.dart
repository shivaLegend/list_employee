import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String inputName = ""; //Name user
  String inputID = ""; // ID user
  String inputRole = ""; //Role of user
  Timestamp inputDOJ = Timestamp.now(); //Date of joining
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['username'] = inputName;
    map['id'] = inputID;
    map["role"] = inputRole;
    map['doj'] = inputDOJ;
    return map;
  }

  // fromMapObject(Map<String, dynamic> map) {
  //   inputName = map['username'];
  //   inputID = map['id'];
  //   inputRole = map['role'];
  //   inputDOJ = map['doj'];
  // }
}
