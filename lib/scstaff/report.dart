import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'homepage.dart';

class Report extends StatefulWidget {
  Report({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  var report;
  // var now = DateTime.now();
  File? pickedImage;
  final GlobalKey<FormState> formReport = GlobalKey<FormState>();
  final fbuser = FirebaseAuth.instance.currentUser;
  final databaseRef = FirebaseDatabase.instance.reference();
  var staffID, staffEmail;

  var descriptionReport = TextEditingController();
  var titleReport = TextEditingController();

  getStaffEmail() async {
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child('Staff')
        .once()
        .then((DataSnapshot snapshot) {
      staffEmail = snapshot.value[fbuser!.uid]['email'];
    });
  }

  saveReport(String title, String reportForm, BuildContext context) async {
    DateTime now = DateTime.now();
    String convertedDateTime =
        "Report Date : ${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} at ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    final useruid = FirebaseAuth.instance.currentUser;
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    String imgURL = "";
    String fileName = basename(pickedImage!.path);

    ////save image to firebase storage
    FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;
    Reference ref =
        firebaseStorageRef.ref().child('upload/$userEmail/$fileName.jpg');
    UploadTask task = ref.putFile(pickedImage!);
    TaskSnapshot snapshot = await task;
    imgURL = await snapshot.ref.getDownloadURL();
    String status = 'Pending';

    ///save user report data to firestore
    FirebaseFirestore.instance.collection('report').doc().set({
      'created-at': convertedDateTime,
      'mark': status,
      'title': title,
      'user-uid': useruid!.uid,
      'description': reportForm,
      'email': userEmail,
      'image-url': imgURL.toString(),
    });
  }

  Future getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (pickedImage == null) return;
    final imageFile = File(pickedImage.path);
    setState(() => this.pickedImage = imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => homePage()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Report a problem'),
        backgroundColor: Color(0xff900C3F),
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text('Submit a report'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Are you confirm to submit this report?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  final FormState? _formReport =
                                      formReport.currentState;
                                  if (_formReport!.validate() &&
                                      pickedImage != null) {
                                    saveReport(titleReport.text,
                                        descriptionReport.text, context);
                                    //uploadImageToFirebase(context);
                                    //Navigator.of(context).pop();
                                    descriptionReport.clear();
                                    titleReport.clear();
                                    setState(() {
                                      pickedImage = null;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Info'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                      'Your report successfully submitted.',
                                                      textAlign:
                                                          TextAlign.center),
                                                  Text(
                                                    'Thank you for your response.',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Okay'))
                                            ],
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: SingleChildScrollView(
                                              child:
                                                  ListBody(children: <Widget>[
                                                Text(
                                                    'Please provide a picture as a proof.'),
                                              ]),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Ok')),
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Text('Yes')),
                          ]);
                    });
              },
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 17),
              ))
        ],
      ),
      body: Container(
        child: Container(
          child: Form(
            key: formReport,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please insert the title';
                      }
                    },
                    controller: titleReport,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      hintText: 'Title : Misplaced parcel',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red.shade900),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                              color: Colors.white,
                              style: BorderStyle.none,
                              width: 0)),
                    )),
                Padding(padding: EdgeInsets.only(top: 10)),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Explain your problem';
                    }
                  },
                  autofocus: false,
                  controller: descriptionReport,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      report = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    hintText: 'Briefly a explain a problem regarding a parcel',
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                            color: Colors.white,
                            style: BorderStyle.none,
                            width: 0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red.shade900),
                    ),
                  ),
                ),
                Container(
                  child: pickedImage != null
                      ? Image.file(pickedImage!)
                      : FittedBox(fit: BoxFit.cover),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            getImage(ImageSource.camera);
                            //print(image);
                          },
                          child: Text('Take a picture'),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(150, 20),
                            primary: Color(0xff900C3F),
                            shape: StadiumBorder(),
                          )),
                      ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(150, 20),
                            primary: Color(0xff900C3F),
                            shape: StadiumBorder()),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
