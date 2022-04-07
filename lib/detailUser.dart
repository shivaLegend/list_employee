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
    Timestamp? datePicker;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail User')),
      body: Center(child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Edit Information"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(text: username),
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Username'),
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: TextEditingController(text: id),
                  decoration: new InputDecoration.collapsed(hintText: 'ID'),
                  onChanged: (String value) {
                    id = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: TextEditingController(text: role),
                  decoration: const InputDecoration.collapsed(hintText: 'Role'),
                  onChanged: (String value) {
                    role = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text("DOJ: "),
                    Text(datePicker == null
                        ? DateFormat('dd/MM/yyyy').format(doj.toDate())
                        : DateFormat('dd/MM/yyyy').format(datePicker!.toDate()))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    child: const Text("Pick date of joining"),
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
                child: const Text("SAVE"),
              ),
            ],
          );
        },
      )),
    );
  }
}
