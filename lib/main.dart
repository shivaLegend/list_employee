import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:list_employee/detailUser.dart';

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
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List listIDDocument = [];
  DateTime selectedDate = DateTime.now();
  String inputName = "";
  String inputID = "";
  String inputRole = "";
  Timestamp inputDOJ = Timestamp.now();
  createUser() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('MyEmployee').get();
    final List<DocumentSnapshot> documents = result.docs;

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyEmployee").doc(inputName);
    Map<String, Object> object = {
      "username": inputName,
      "id": inputID,
      "role": inputRole,
      "doj": inputDOJ
    };
    documentReference
        .set(object)
        .whenComplete(() => print("$inputName created"));
  }

  deleteUser(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyEmployee").doc(item);
    documentReference.delete().whenComplete(() => print("delete successfully"));
  }

  Future<void> getData() async {
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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List employee"),
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
                    title: Text(""),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: new InputDecoration.collapsed(
                              hintText: 'Username'),
                          onChanged: (String value) {
                            inputName = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration:
                              new InputDecoration.collapsed(hintText: 'ID'),
                          onChanged: (String value) {
                            inputID = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration:
                              new InputDecoration.collapsed(hintText: 'Role'),
                          onChanged: (String value) {
                            inputRole = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("DOJ: "),
                            Text(DateFormat('dd/MM/yyyy')
                                .format(datePicker.toDate()))
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
                                  datePicker = Timestamp.fromDate(
                                      value ?? DateTime.now());
                                  inputDOJ = datePicker;
                                });
                              });
                            }),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (inputName == "") {
                              return;
                            }
                            createUser();
                            Navigator.of(context).pop();
                            // contentText = "Changed Content of Dialog";
                          });
                        },
                        child: Text("ADD"),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
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
                return Dismissible(
                    key: Key(index.toString()),
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailUser(
                                    username: documentSnapshot != null
                                        ? documentSnapshot["username"]
                                        : "",
                                    id: documentSnapshot != null
                                        ? documentSnapshot["id"]
                                        : "",
                                    role: documentSnapshot != null
                                        ? documentSnapshot["role"]
                                        : "",
                                    doj: documentSnapshot != null
                                        ? documentSnapshot["doj"]
                                        : Timestamp.now(),
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
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                // todos.removeAt(index);
                                deleteUser(documentSnapshot != null
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
