// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'adminhomepage.dart';

class ReportReview extends StatefulWidget {
  const ReportReview({Key? key}) : super(key: key);

  @override
  _ReportReviewState createState() => _ReportReviewState();
}

class _ReportReviewState extends State<ReportReview> {
  var imgURL, img, markdone = 'Done';
  CollectionReference reportRef =
      FirebaseFirestore.instance.collection('report');

  Future<void> deleteUser(id) {
    return reportRef
        .doc(id)
        .delete()
        .then((value) {})
        // ignore: invalid_return_type_for_catch_error, avoid_print
        .catchError((error) => print('Failed to Delete user report: $error'));
  }

  Future<void> update(id) {
    DateTime dateNow = DateTime.now();
    var formatDate =
        "${dateNow.year.toString()}-${dateNow.month.toString()}-${dateNow.day.toString()} at ${dateNow.hour.toString()}:${dateNow.minute.toString()}";
    final databaseRef = FirebaseFirestore.instance.collection('report');
    return databaseRef.doc(id).update({'mark': 'Done', 'dateDone': formatDate});
  }

  getImage() async {
    FirebaseFirestore.instance.collection('report').doc().get().then((ds) {
      imgURL = ds.data()!['imageURL'];
    });
  }

  final Stream<QuerySnapshot> staffStream =
      FirebaseFirestore.instance.collection('report').snapshots();

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
        title: Text('Report Review'),
        backgroundColor: Color(0xff900C3F),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: staffStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went Wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final List storedocs = [];
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              //DateTime dt = (storedocs[i]['created-at'] as Timestamp).toDate();
              storedocs.add(a);
              a['id'] = document.id;
            }).toList();

            // ignore: avoid_unnecessary_containers
            return Container(
              //margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      for (var i = 0; i < storedocs.length; i++) ...[
                        Card(
                          child: ListTile(
                            leading: Image.network(
                                storedocs[i]['image-url'].toString()),
                            //leading: FlutterLogo(size: 72.0),
                            title: Text(storedocs[i]['title']),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Text(storedocs[i]['description']),
                                Padding(padding: EdgeInsets.only(top: 5)),
                                Text(storedocs[i]['created-at']),
                                Padding(padding: EdgeInsets.only(top: 5)),
                                if (storedocs[i]['mark'] == 'Done') ...[
                                  Text(
                                    'Status : ${storedocs[i]['mark']}',
                                    style: TextStyle(
                                        backgroundColor: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ] else if (storedocs[i]['mark'] ==
                                    'Pending') ...[
                                  Text(
                                    'Status : ${storedocs[i]['mark']}',
                                    style: TextStyle(
                                      backgroundColor: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                                Padding(padding: EdgeInsets.only(top: 5)),
                                if (storedocs[i]['dateDone'] == null) ...[
                                  Text('Not review yet'),
                                ] else ...[
                                  Text(
                                      'Task done : ${storedocs[i]['dateDone'].toString()}'),
                                ],
                              ],
                            ),
                            // IconButton(onPressed: (){},Icons.more_vert),
                            trailing: PopupMenuButton(
                                icon: Icon(Icons.more_horiz),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          value: 1,
                                          child: TextButton(
                                            child: Text(
                                              'View',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        'Subject : ${storedocs[i]['title']}',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ListBody(
                                                            children: <Widget>[
                                                              Text(
                                                                  'Status : ${storedocs[i]['mark']}'),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10)),
                                                              Text(
                                                                storedocs[i][
                                                                    'description'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                              ),
                                                              Image.network(
                                                                storedocs[i][
                                                                        'image-url']
                                                                    .toString(),
                                                                height: 300,
                                                              ),
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 10)),
                                                              //Text(storedocs[i]['created-at'])
                                                            ]),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text('Back')),
                                                        TextButton(
                                                            onPressed: () {
                                                              update(
                                                                  storedocs[i]
                                                                      ['id']);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Mark as done')),
                                                      ],
                                                    );
                                                  });
                                            },
                                          )),
                                      PopupMenuItem(
                                          value: 1,
                                          child: TextButton(
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Delete this report?'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ListBody(
                                                            // ignore: prefer_const_literals_to_create_immutables
                                                            children: <Widget>[
                                                              Text(
                                                                  'This report will delete permanently.')
                                                            ]),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              if (storedocs[i][
                                                                      'mark'] ==
                                                                  'Pending') {}
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text('Cancel')),
                                                        TextButton(
                                                            onPressed: () {
                                                              if (storedocs[i][
                                                                      'mark'] ==
                                                                  "Pending") {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                            'Warning!'),
                                                                        content:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              ListTile(
                                                                            subtitle:
                                                                                Column(children: <Widget>[
                                                                              Text('Please review this report before delete.')
                                                                            ]),
                                                                          ),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Text('Okay'))
                                                                        ],
                                                                      );
                                                                    });
                                                              } else if (storedocs[
                                                                          i][
                                                                      'mark'] ==
                                                                  "Done") {
                                                                deleteUser(storedocs[
                                                                            i]
                                                                        ['id'])
                                                                    .whenComplete(() =>
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return AlertDialog(
                                                                                  content: SingleChildScrollView(
                                                                                    // ignore: prefer_const_literals_to_create_immutables
                                                                                    child: ListBody(children: <Widget>[
                                                                                      Text('Report is successful deleted.')
                                                                                    ]),
                                                                                  ),
                                                                                  actions: <Widget>[
                                                                                    TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        child: Text('Ok'))
                                                                                  ]);
                                                                            }));
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }
                                                            },
                                                            child: Text('Yes'))
                                                      ],
                                                    );
                                                  });
                                              //Navigator.of(context).pop();
                                            },
                                          ))
                                    ]),

                            isThreeLine: true,
                          ),
                        )
                      ]
                    ],
                  )),
            );
          }),
    );
  }
}
