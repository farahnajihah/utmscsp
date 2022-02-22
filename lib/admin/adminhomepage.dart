import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:utmscsm_app/admin/loghistory.dart';
import 'package:utmscsm_app/admin/reportreview.dart';
import 'package:utmscsm_app/admin/stafflog.dart';
import 'package:utmscsm_app/scstaff/stafflogin.dart';
import 'manageuser.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  //var name, _email, staffid, phoneNumber, userID;
  
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
        //backgroundColor: Colors.transparent,
        backgroundColor: Color(0xff900C3F),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: EdgeInsets.only(top: 20),
            //child: Text('Logout'),
          ),
          IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.logout)),
        ],
        //centerTitle: true,
        title: Text(
          "Admin Dashboard",
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white24,
          // gradient: LinearGradient(
          //   colors: const [Colors.white24, Color(0xff900C3F)],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(60),
              child: Image(
                image: AssetImage('assets/logo.png'),
                width: 200.0,
                height: 200.0,
              ),
            ),
            // Container(
            //   padding: EdgeInsets.only(right: 40, left: 40),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => LogHistory()),
            //       );
            //     },
            //     child: Text('Log History'),
            //     style: ElevatedButton.styleFrom(
            //       primary: Color(0xff900C3F),
            //       shape: StadiumBorder(),
            //       fixedSize: Size(40, 50),
            //       //padding: const EdgeInsets.symmetric( horizontal: 60,vertical: 15),
            //       textStyle: const TextStyle(fontSize: 20),
            //     ),
            //   ),
            // ),
            Container(
              padding: EdgeInsets.only(right: 40, left: 40),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageUser()),
                  );
                },
                child: Text('Manage User'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff900C3F),
                  shape: StadiumBorder(),
                  fixedSize: Size(40, 50),
                  //padding: const EdgeInsets.symmetric( horizontal: 60,vertical: 15),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 40, left: 40, top: 20),
              child: ElevatedButton(
                onPressed: () {

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => StaffMailLog()));
                },
                child: Text('Staff Log'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff900C3F),
                  shape: StadiumBorder(),
                  fixedSize: Size(40, 50),
                  //padding: const EdgeInsets.symmetric( horizontal: 60,vertical: 15),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 40, left: 40, top: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ReportReview()));
                },
                child: Text('Report Log'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff900C3F),
                  shape: StadiumBorder(),
                  fixedSize: Size(40, 50),
                  //padding: const EdgeInsets.symmetric( horizontal: 60,vertical: 15),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
