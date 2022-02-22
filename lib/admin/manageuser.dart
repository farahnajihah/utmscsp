import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:utmscsm_app/scstaff/stafflogin.dart';

import 'adminhomepage.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({Key? key}) : super(key: key);

  @override
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  final databaseRef = FirebaseDatabase.instance.reference().child('Staff');

  signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then((value) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        ));
  }

  @override
  void initState() {
    super.initState();
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
        title: Text('Manage User'),
      ),
      body: Container(
        decoration: BoxDecoration(

            ///color: Colors.white,
            // gradient: LinearGradient(
            //   colors: const [Color(0xffA3E4D7), Color(0xffC39BD3)],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            // ),
            ),
        child: FirebaseAnimatedList(
          query: databaseRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return Card(
              child: ListTile(
                leading: Image.network(snapshot.value['profile-pictureURL']),
                contentPadding: EdgeInsets.all(15),
                tileColor: Colors.grey.shade100,
                //title: Text('Id : ${snapshot.key.toString()}'),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('ID',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(snapshot.key.toString()),
                    Padding(padding: EdgeInsets.only(top:10)),
                    Text('Name',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(snapshot.value['name']),
                    Padding(padding: EdgeInsets.only(top:10)),
                    Text('Email',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(snapshot.value['email']),
                    // Text('Email             : ${snapshot.value['email']}'),
                    // //Text('Mail Status   : ${snapshot.value['mail-status']}'),
                    // Text('Contact         : ${snapshot.value['phone-number']}'),
                  ],
                ),
                trailing: 
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete this user?'),
                            content: SingleChildScrollView(
                              child: ListBody(children: <Widget>[
                                Text(
                                    'Are sure want to delete all the data about ${snapshot.value['name']}?')
                              ]),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    databaseRef
                                        .child(snapshot.key.toString())
                                        .remove()
                                        .whenComplete(
                                            () => Navigator.of(context).pop());
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Info'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                      'User ${snapshot.value['name']} successfully deleted.',
                                                      textAlign:
                                                          TextAlign.center),
                                                  Text(
                                                    'Thank you for your response.',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Text('Yes'))
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.delete),
                ),
                //Text('Email : ${snapshot.value['email']}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
