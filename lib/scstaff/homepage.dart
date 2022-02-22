import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmscsm_app/scstaff/report.dart';
import 'package:utmscsm_app/scstaff/stafflogin.dart';
import 'package:utmscsm_app/scstaff/scstaffprofile.dart';
import 'package:utmscsm_app/scstaff/mailstatus.dart';

// ignore: camel_case_types
class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

// ignore: camel_case_types
class _homePageState extends State<homePage> {
  double bgWidth = 40.0;
  double bgHeight = 40.0;
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
      appBar:
          AppBar(
        backgroundColor: Color(0xff900C3F),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: EdgeInsets.only(top: 20),
          ),
          // IconButton(
          //     onPressed: () {
          //       signOut();
          //     },
          //     icon: Icon(Icons.logout)),
        ],
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
      // ),
      body: Container(
        decoration: BoxDecoration(
          
          // ignore: unnecessary_new
          // image: new DecorationImage(
          //     image: AssetImage('assets/utm3.png'),
          //     alignment: Alignment.bottomCenter),
          color: Colors.white,
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
            Container(
              padding: EdgeInsets.only(right: 40, left: 40),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StaffProfile2()),
                  );
                },
                child: Text('Profile'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Color(0xff900C3F),
                  fixedSize: Size(40, 50),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 40, left: 40, top: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MailStatus()),
                  );
                },
                child: Text('Mail Status'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Color(0xff900C3F),
                  fixedSize: Size(40, 50),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 40, left: 40, top: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Report()),
                  );
                },
                child: Text('Report a problem'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: Color(0xff900C3F),
                  fixedSize: Size(40, 50),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
