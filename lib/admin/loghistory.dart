// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'adminhomepage.dart';

// class LogHistory extends StatefulWidget {
//   LogHistory({Key? key}) : super(key: key);

//   @override
//   _LogHistoryState createState() => _LogHistoryState();
// }

// class _LogHistoryState extends State<LogHistory> {
//   var dateLog, timeLog, userID;
//   final dataRef = FirebaseDatabase.instance.reference().child('Staff');

//   final Stream<QuerySnapshot> receiveLog =
//       FirebaseFirestore.instance.collection('receivedLog').snapshots();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AdminHomePage()),
//             );
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//         backgroundColor: Color(0xff900C3F),
//         actions: [
//           Container(
//             padding: EdgeInsets.only(top: 20),
//             //child: Text('Logout'),
//           ),
//           IconButton(
//               onPressed: () {
//                 //signOut();
//               },
//               icon: Icon(Icons.logout)),
//         ],
//         title: Text('Staff Mail Status Log'),
//       ),
//       body: Container(
//           child: FirebaseAnimatedList(
//               query: dataRef,
//               itemBuilder: (BuildContext context, DataSnapshot snapshot,
//                   Animation<double> animation, int index) {

//                 var log = snapshot.value['log'];
//                 var dates = log.keys.toList();
//                 var key = dates[index];
//                 return Card(
//                   child: ListTile(
//                     title: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text('Email             :  ${snapshot.value['email']}'),
//                         Text(
//                             'Mail Status   :  ${snapshot.value['mail-status'].toString()}'),
//                         Text('Date               :  ${snapshot.value['date']}'),
//                         Text('Time              :  ${snapshot.value['time']}'),


//                         Card(
//                           child: ListTile(
//                             title: Text('Log History', textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                            
//                             subtitle: Column(
//                               children: <Widget>[
//                                 Padding(padding: EdgeInsets.only(top:10)),
//                                 for(var i = 0; i<log.length; i++)...[
//                                   Text(snapshot.value['log'][key]['current-date']),
//                                    Text(snapshot.value['log'][key]['time'].toString())
//                                 ],       
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               })),
//     );
//   }
// }
