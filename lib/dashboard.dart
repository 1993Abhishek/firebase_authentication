import 'package:flutter/material.dart';

class DashBoard extends StatelessWidget {
  TextEditingController _controller=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: Column(
        children: <Widget>[
          Center(child: Text("Insert data"),),
          TextFormField(
            decoration: InputDecoration(
                labelText: "Email",
                fillColor: Colors.white60,
                focusColor: Colors.white60,
                hintText: "Email"),
            controller: _controller,
//            focusNode: _nodeEmail,
            cursorColor: Colors.white70,
            validator: (value) {
              if (value.isEmpty) {
                return "Please give an Valid Email";
              }
            },
            onFieldSubmitted: (value) {
//              _nodeEmail.unfocus();
//              _nodePassword.requestFocus();
            },
            style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 20,
//              backgroundColor: Colors.white60,
            ),
          ),

          FloatingActionButton(
            isExtended: true,
            autofocus: true,
            splashColor: Colors.greenAccent,
            elevation: 20,
            backgroundColor: Colors.white30,
            onPressed: () {
//              signIn(
//                _controllerMail.text,
//                _controllerPassword.text,
//              );
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
    );
  }
}
