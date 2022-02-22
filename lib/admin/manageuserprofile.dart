// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:utmscsm_app/admin/adminhomepage.dart';

// class ManageUserProfile extends StatefulWidget {
//   const ManageUserProfile({Key? key}) : super(key: key);

//   @override
//   _ManageUserProfileState createState() => _ManageUserProfileState();
// }

// class _ManageUserProfileState extends State<ManageUserProfile> {
//   // For Deleting User

//   CollectionReference staff = FirebaseFirestore.instance.collection('Staff');

//   Future<void> deleteUser(id) {
//     // print("User Deleted $id");
//     return staff
//         .doc(id)
//         .delete()
//         .then((value) => print('User Deleted'))
//         .catchError((error) => print('Failed to Delete user: $error'));
//   }

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
//         backgroundColor: Color(0xffC39BD3),
//         centerTitle: true,
//         title: Text('Manage User Profile'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('Staff').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasError) {
//             return Text('Something went wrong');
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Text('Loading.....');
//           }

//           final List staffdocs = [];
//           snapshot.data.docs.map((DocumentSnapshot document) {
//             Map a = document.data() as Map<String, dynamic>;
//             staffdocs.add(a);
//             a['id'] = document.id;
//           }).toList();

//           return Container(
//               margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//               child: SingleChildScrollView(
//                 child: Table(
//                   border: TableBorder.all(),
//                   columnWidths: const <int, TableColumnWidth>{
//                     1: FixedColumnWidth(180),
//                   },
//                   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                   children: [
//                     TableRow(children: [
//                       TableCell(
//                         child: Container(
//                           color: Colors.purple.shade200,
//                           child: Center(
//                             child: Text(
//                               'Name',
//                               style: TextStyle(
//                                   fontSize: 16.0, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ),
//                       TableCell(
//                         child: Container(
//                           color: Colors.purple.shade200,
//                           child: Center(
//                             child: Text(
//                               'Email',
//                               style: TextStyle(
//                                   fontSize: 16.0, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ),
//                       TableCell(
//                         child: Container(
//                           color: Colors.purple.shade200,
//                           child: Center(
//                             child: Text(
//                               'Action',
//                               style: TextStyle(
//                                   fontSize: 16.0, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ]),
//                     for (var i = 0; i < staffdocs.length; i++) ...[
//                       TableRow(
//                         children: [
//                           TableCell(
//                               child: Center(
//                                   child: Text(staffdocs[i]['name'],
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(fontSize: 14.0)))),
//                           TableCell(
//                               child: Center(
//                                   child: Text(staffdocs[i]['email'],
//                                       style: TextStyle(fontSize: 14.0)))),
//                           TableCell(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 IconButton(
//                                     onPressed: () {
//                                       deleteUser(staffdocs[i]['id']);
//                                     },
//                                     icon: Icon(Icons.delete, color: Colors.red))
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ]
//                   ],
//                 ),
//               ));
//           // return ListView(
//           //   padding: EdgeInsets.all(20),
//           //   children: snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
//           //     Map<String, dynamic> data =
//           //         document.data() as Map<String, dynamic>;
//           //     return ListTile(
//           //       title: Text(data['email']),
//           //     );
//           //   }).toList(),
//           // );
//         },
//       ),
//     );
//   }
// }
