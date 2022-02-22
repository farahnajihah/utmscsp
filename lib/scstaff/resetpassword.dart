import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmscsm_app/scstaff/stafflogin.dart';
import 'package:utmscsm_app/widget/button.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Reset password'),
        backgroundColor: Color(0xff900C3F),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Colors.white24,
          gradient: LinearGradient(
            colors: const [Colors.white24, Color(0xffC50000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(30.0)),
            Image(
              image: AssetImage('assets/logo.png'),
              width: 200.0,
              height: 200.0,
            ),

            //USERNAME FORMFIELD
            Padding(padding: const EdgeInsets.all(10.0)),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              validator: (staffuser) {
                if (staffuser == null || staffuser.isEmpty) {
                  return 'Please enter your email';
                }
              },
              style: TextStyle(fontSize: 17.0),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.red.shade900)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(color: Colors.red.shade900)),
                labelText: 'Email',
              ),
            ),
            // ignore: unnecessary_new
            SizedBox(
              height: 20,
            ),
            Button(
              onPressed: () {
                auth.sendPasswordResetEmail(email: _email);
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Reset password'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('An email has been sent to $_email'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              child: Text('Okay'))
                        ],
                      );
                    });
              },
              name: "Send request",
            ),
          ],
        ),
      ),
    );
  }

  void signInwithEmailAndPassword(String text, String text2) {}
}
