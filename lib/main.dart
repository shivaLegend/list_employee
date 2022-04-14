import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:list_employee/view/detailUser.dart';
import 'package:list_employee/model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.red,
      accentColor: Colors.green,
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List listIDDocument = []; //List ID of document in Firestore
  User user = User();
  createUserFirestore() async {
    //Create user on firestore
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyEmployee").doc(user.inputName);
    Map<String, dynamic> object = user.toMap();
    documentReference
        .set(object)
        .whenComplete(() => print("$user.inputName created"));
  }

  deleteUserFirestore(item) {
    //delete user on firestore
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyEmployee").doc(item);
    documentReference.delete().whenComplete(() => print("delete successfully"));
  }

  Future<void> getListIDDocumentFirestore() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('MyEmployee');

    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs;
    listIDDocument = [];
    for (final e in allData) {
      listIDDocument.add(e.id);
    }
    print(listIDDocument);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListIDDocumentFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List employee"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              Timestamp datePicker = Timestamp.now();
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text(""),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Username'),
                          onChanged: (String value) {
                            user.inputName = value;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration:
                              const InputDecoration.collapsed(hintText: 'ID'),
                          onChanged: (String value) {
                            user.inputID = value;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration:
                              const InputDecoration.collapsed(hintText: 'Role'),
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
                            Text(DateFormat('dd/MM/yyyy')
                                .format(datePicker.toDate()))
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
                                  datePicker = Timestamp.fromDate(
                                      value ?? DateTime.now());
                                  user.inputDOJ = datePicker;
                                });
                              });
                            }),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (user.inputName == "") {
                              return;
                            }
                            createUserFirestore();
                            getListIDDocumentFirestore();
                            Navigator.of(context).pop();
                            // contentText = "Changed Content of Dialog";
                          });
                        },
                        child: const Text("ADD"),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("MyEmployee").snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                QueryDocumentSnapshot<Object?>? documentSnapshot =
                    snapshot.data?.docs[index];
                User tempUser = User();
                tempUser.inputName = documentSnapshot != null
                    ? documentSnapshot["username"]
                    : "";
                tempUser.inputID =
                    documentSnapshot != null ? documentSnapshot["id"] : "";
                tempUser.inputRole =
                    documentSnapshot != null ? documentSnapshot["role"] : "";
                tempUser.inputDOJ = documentSnapshot != null
                    ? documentSnapshot["doj"]
                    : Timestamp.now();
                return Dismissible(
                    key: Key(index.toString()),
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailUser(
                                    user: tempUser,
                                    idOfDoc: listIDDocument[index],
                                  )));
                        },
                        child: ListTile(
                          title: Text(documentSnapshot != null
                              ? (index + 1).toString() +
                                  ". " +
                                  documentSnapshot["username"]
                              : (index + 1).toString() + ". " + ""),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                // todos.removeAt(index);
                                deleteUserFirestore(documentSnapshot != null
                                    ? listIDDocument[index]
                                    : "");
                              });
                            },
                          ),
                        ),
                      ),
                    ));
              },
            );
          }),
    );
  }
}
