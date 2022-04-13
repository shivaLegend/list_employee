import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:list_employee/model/user.dart';

class DetailUser extends StatelessWidget {
  var collection = FirebaseFirestore.instance.collection('MyEmployee');
  String idOfDoc = ""; //ID of document on firestore
  User user = User();
  DetailUser({Key? key, required this.idOfDoc, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timestamp? datePicker;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail User')),
      body: Center(child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: TextEditingController(text: user.inputName),
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Username'),
                  onChanged: (String value) {
                    user.inputName = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: TextEditingController(text: user.inputID),
                  decoration: const InputDecoration.collapsed(hintText: 'ID'),
                  onChanged: (String value) {
                    user.inputID = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: TextEditingController(text: user.inputRole),
                  decoration: const InputDecoration.collapsed(hintText: 'Role'),
                  onChanged: (String value) {
                    user.inputRole = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text("DOJ: "),
                    Text(datePicker == null
                        ? DateFormat('dd/MM/yyyy')
                            .format(user.inputDOJ.toDate())
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
                          user.inputDOJ = datePicker!;
                        });
                      });
                    }),
                TextButton(
                  onPressed: () {
                    setState(() {
                      Map<String, dynamic> object = user.toMap();
                      collection.doc(idOfDoc).update(object);
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text("SAVE"),
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
