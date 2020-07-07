import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/dashboard.dart';
import 'package:firebase_authentication/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controllerMail,
      _controllerPassword,
      _controllerMessage;
  FocusNode _nodeEmail, _nodePassword, _nodeMessage;

  @override
  void initState() {
    // TODO: implement initState
    _controllerPassword = TextEditingController();
    _controllerMail = TextEditingController();
    _controllerMessage = TextEditingController();

    _nodePassword = FocusNode();
    _nodeEmail = FocusNode();
    _nodeMessage = FocusNode();

    super.initState();
  }

  Future<void> signIn(
    String mail,
    String password,
  ) async {
    try {
      AuthResult result =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mail,
        password: password,
      );
//      print(result.user.uid);
      if (result.user.uid.isNotEmpty) {
        print(result.user.uid);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DashBoard(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signUp(
    String mail,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
//      Navigator.of(context).push(
//        MaterialPageRoute(
//          builder: (context) => Home(),
//        ),
//      );
    } catch (e) {
      print(e.message);
    }
  }

  QuerySnapshot data;

  Future<void> getData() async {
    await Firestore.instance.collection("Tester").getDocuments().then((value) {
      setState(() {
        data = value;
      });
    });
    for (int i = 0; i < data.documents.length; i++) {
      print(data.documents[i].data["msg"]);
    }
  }

  Future<void> addData(
    dynamic data,
  )
  {
    Firestore.instance.collection("Tester").add(data).catchError((e) {
      print(e);
    });
  }

  updateData(selectedDoc, newValues) {
    Firestore.instance
        .collection("Tester")
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId) {
    Firestore.instance
        .collection("Tester")
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.white30,
        title: Center(
          child: Text(
            "Sign in",
            style: TextStyle(
              fontSize: 25,
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Email",
                    fillColor: Colors.white60,
                    focusColor: Colors.white60,
                    hintText: "Email"),
                controller: _controllerMail,
                focusNode: _nodeEmail,
                cursorColor: Colors.white70,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please give an Valid Email";
                  }
                },
                onFieldSubmitted: (value) {
                  _nodeEmail.unfocus();
                  _nodePassword.requestFocus();
                },
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 20,
//              backgroundColor: Colors.white60,
                ),
              ),
              Container(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value.length < 6) {
                    return "Password should be more than 6 charecters";
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    fillColor: Colors.white60,
                    focusColor: Colors.white60,
                    hintText: "Password"),
                controller: _controllerPassword,
                focusNode: _nodePassword,
                cursorColor: Colors.white70,
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 20,
//              backgroundColor: Colors.white60,
                ),
              ),
              Container(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value.length < 6) {
                    return "Message should be more than 6 charecters";
                  }
                },
                decoration: InputDecoration(
                  labelText: "Message",
                  fillColor: Colors.white60,
                  focusColor: Colors.white60,
                  hintText: "Write something",
                ),
                controller: _controllerMessage,
                focusNode: _nodeMessage,
                cursorColor: Colors.white70,
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 20,
//              backgroundColor: Colors.white60,
                ),
              ),
              Container(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    isExtended: true,
                    autofocus: true,
                    splashColor: Colors.greenAccent,
                    elevation: 20,
                    backgroundColor: Colors.lightBlueAccent,
                    onPressed: () {
                      getData();
                    },
                    tooltip: 'Get Data',
                    child: Icon(
                      Icons.cloud_download,
                      color: Colors.white60,
                      size: 40,
                    ),
                  ),
                  Container(
                    width: 50,
                  ),
                  FloatingActionButton(
                    isExtended: true,
                    autofocus: true,
                    splashColor: Colors.greenAccent,
                    elevation: 20,
                    backgroundColor: Colors.lightBlueAccent,
                    onPressed: () {
                      dynamic data = {
                        "email": _controllerMail.text,
                        "password": _controllerPassword.text,
                        "msg": _controllerMessage.text,
                      };
                      addData(data);
                    },
                    tooltip: 'Add Data',
                    child: Icon(
                      Icons.add_circle_outline,
                      color: Colors.white60,
                      size: 40,
                    ),
                  ),
                  Container(
                    width: 50,
                  ),
                  FloatingActionButton(
                    isExtended: true,
                    autofocus: true,
                    splashColor: Colors.greenAccent,
                    elevation: 20,
                    backgroundColor: Colors.white70,
                    onPressed: () {
                      signUp(
                        _controllerMail.text,
                        _controllerPassword.text,
                      );
                    },
                    tooltip: 'Sign Up',
                    child: Icon(
                      Icons.save,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                  Container(
                    width: 50,
                  ),
                  FloatingActionButton(
                    isExtended: true,
                    autofocus: true,
                    splashColor: Colors.greenAccent,
                    elevation: 20,
                    backgroundColor: Colors.white30,
                    onPressed: () {
                      signIn(
                        _controllerMail.text,
                        _controllerPassword.text,
                      );
                    },
                    tooltip: 'Submit',
                    child: Icon(
                      Icons.save,
                      color: Colors.lightBlueAccent,
                      size: 40,
                    ),
                  ),
                ],
              ),
              Container(height: 25,),
              Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                FloatingActionButton(
                  isExtended: true,
                  autofocus: true,
                  splashColor: Colors.greenAccent,
                  elevation: 20,
                  backgroundColor: Colors.yellow,
                  onPressed: () {
                    dynamic datam={
                      "email":_controllerMail.text,
                      "password":_controllerPassword.text,
                      "msg":_controllerMessage.text,
                    };
                    updateData(data.documents[0].documentID, datam);
                  },
                  tooltip: 'Update Data',
                  child: Icon(
                    Icons.cloud_upload,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                Container(width: 50,),
                FloatingActionButton(
                  isExtended: true,
                  autofocus: true,
                  splashColor: Colors.greenAccent,
                  elevation: 20,
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    deleteData(data.documents[2].documentID);
                  },
                  tooltip: 'Delete Data',
                  child: Icon(
                    Icons.cloud_off,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],)
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
