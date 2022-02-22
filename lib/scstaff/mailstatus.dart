import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:utmscsm_app/scstaff/stafflogin.dart';
import 'homepage.dart';

class MailStatus extends StatefulWidget {
  const MailStatus({Key? key}) : super(key: key);

  @override
  _MailStatusState createState() => _MailStatusState();
}

class _MailStatusState extends State<MailStatus> {
  // ignore: prefer_typing_uninitialized_variables
  var count;
  var newCountValue;
  var num;
  final databaseRef = FirebaseDatabase.instance.reference();
///// get user mail counter
  mailStatus() async {
    final fbUser = FirebaseAuth.instance.currentUser;
    await databaseRef
        .child('Staff')
        .child(fbUser!.uid)
        .once()
        .then((DataSnapshot snapshot) {
      count = snapshot.value['mail-status'].toString();
    });
  }

  /////// reset the counter
  resetCountMail() async {
    final fbuser = FirebaseAuth.instance.currentUser;
    setState(() {
      num = 0;
      databaseRef
          .child('Staff')
          .child(fbuser!.uid)
          .update({'mail-status': num});
    });
  }

  resectCounterLog() async {
    final useruid = FirebaseAuth.instance.currentUser;
    DateTime dateNow = DateTime.now();
    var formatDate =
        "${dateNow.year.toString()}-${dateNow.month.toString()}-${dateNow.day.toString()} at ${dateNow.hour.toString()}:${dateNow.minute.toString()}";
    String receivedStatus = 'Done';

    final dataReal = FirebaseDatabase.instance
        .reference()
        .child('Staff')
        .child(useruid!.uid)
        .update({
      'received-status': receivedStatus,
      'received-date': formatDate,
      'mail-received': count,
    });
  }

  signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then((value) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        ));
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> refreshList() async {
    final fbUser = FirebaseAuth.instance.currentUser;
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      databaseRef
          .child('Staff')
          .child(fbUser!.uid)
          .once()
          .then((DataSnapshot snapshot) {
        count = snapshot.value['mail-status'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => homePage()),
        //     );
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
        //centerTitle: true,
        title: Text('Mail Status'),
        backgroundColor: Color(0xff900C3F),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       signOut();
          //     },
          //     icon: Icon(Icons.logout))
        ],
      ),
      body: RefreshIndicator(
          key: refreshKey,
          // padding: EdgeInsets.all(30.0),
          // decoration: BoxDecoration(
          //   color: Colors.white24,
          //   // gradient: LinearGradient(
          //   //   colors: const [Colors.white, Color(0xff900C3F)],
          //   //   begin: Alignment.topCenter,
          //   //   end: Alignment.bottomCenter,
          //   // ),
          // ),
          onRefresh: refreshList,
          child: FutureBuilder(
              future: mailStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                  //return Text("Loading....Please wait");
                } else if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                return ListView(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 20, left: 20),
                        color: Colors.transparent,
                        child: Image(
                          image: AssetImage('assets/email.png'),
                          width: 200.0,
                          height: 200.0,
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 20),
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                        Text(
                        'You have ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(' '),
                      Text( count,style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.red.shade900),),
                      Text('parcel/mail in your pigeonhole box',textAlign: TextAlign.center,style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      Padding(padding: EdgeInsets.only(top:20)),
                      Text('Please pull to refresh the page.',textAlign: TextAlign.center,style: TextStyle(fontSize: 13.0),),
                      ],),
                      
                      
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 40, left: 40, top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          resetCountMail();
                          resectCounterLog();
                        },
                        child: Text('Received'),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          primary: Color(0xff900C3F),
                          fixedSize: Size(40, 50),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Please tap on Received button after you take a parcel/mail from your pigeonhole box to reset UTMSM counter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}
