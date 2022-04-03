import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailUser extends StatelessWidget {
  var collection = FirebaseFirestore.instance.collection('MyEmployee');
  String idOfDoc = "";
  String username = "";
  String id = "";
  String role = "";
  Timestamp doj = Timestamp.now();
  DetailUser(
      {Key? key,
      required this.idOfDoc,
      required this.username,
      required this.id,
      required this.role,
      required this.doj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timestamp? datePicker = null;
    return Scaffold(
      appBar: AppBar(title: Text('Detail User')),
      body: Center(child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Edit Information"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(text: "$username"),
                  decoration:
                      new InputDecoration.collapsed(hintText: 'Username'),
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: TextEditingController(text: "$id"),
                  decoration: new InputDecoration.collapsed(hintText: 'ID'),
                  onChanged: (String value) {
                    id = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: TextEditingController(text: "$role"),
                  decoration: new InputDecoration.collapsed(hintText: 'Role'),
                  onChanged: (String value) {
                    role = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text("DOJ: "),
                    Text(datePicker == null
                        ? DateFormat('dd/MM/yyyy').format(doj.toDate())
                        : DateFormat('dd/MM/yyyy').format(datePicker!.toDate()))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    child: Text("Pick date of joining"),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2023))
                          .then((value) {
                        setState(() {
                          datePicker =
                              Timestamp.fromDate(value ?? DateTime.now());
                          doj = datePicker!;
                        });
                      });
                    }),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    Map<String, Object> object = {
                      "username": username,
                      "id": id,
                      "role": role,
                      "doj": doj
                    };
                    collection.doc(idOfDoc).update(object);
                    Navigator.of(context).pop();
                  });
                },
                child: Text("SAVE"),
              ),
            ],
          );
        },
      )),
    );
  }
}
