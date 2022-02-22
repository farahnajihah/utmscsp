// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:utmscsm_app/scstaff/stafflogin.dart';

import 'adminhomepage.dart';

class StaffMailLog extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  StaffMailLog({Key? key}) : super(key: key);

  @override
  _StaffMailLogState createState() => _StaffMailLogState();
}

class _StaffMailLogState extends State<StaffMailLog> {
  final databaseRef = FirebaseDatabase.instance.reference().child('Staff');
  final authUser = FirebaseAuth.instance;
  var currentDate, currentTime, staffemail;
  final logHistory = FirebaseDatabase.instance.reference().child('Log');

  signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then((value) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminHomePage()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Color(0xff900C3F),
        actions: [
          Container(
            padding: EdgeInsets.only(top: 20),
            //child: Text('Logout'),
          ),
          // IconButton(
          //     onPressed: () {
          //       signOut();
          //     },
          //     icon: Icon(Icons.logout)),
        ],
        //centerTitle: true,
        title: Text('Staff Log'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white24,
        ),
        child: FirebaseAnimatedList(
          query: databaseRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return Card(
              child: ListTile(
                contentPadding: EdgeInsets.all(30),
                tileColor: Colors.white,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Name', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(snapshot.value['name']),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text('Email', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(snapshot.value['email']),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Text('Staff ID', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(snapshot.value['username']),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                        'Mail Status   : ${snapshot.value['mail-status'].toString()}'),
                    Text(
                        'Date               : ${snapshot.value['date'].toString()}'),
                    Text(
                        'Time              : ${snapshot.value['time'].toString()}'),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Text(
                      'Collected Log',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900),
                    ),
                    Text('Parcel/Mail received'),
                    Text(
                      snapshot.value['mail-received'].toString(),
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    Text(
                        'Received at      : ${snapshot.value['received-date'].toString()}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
