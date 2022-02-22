/////STAFFPROFILE REALTIME

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:utmscsm_app/scstaff/stafflogin.dart';
import 'package:utmscsm_app/scstaff/updateprofile.dart';
import 'homepage.dart';

class StaffProfile2 extends StatefulWidget {
  StaffProfile2({Key? key}) : super(key: key);

  @override
  _StaffProfile2State createState() => _StaffProfile2State();
}

class _StaffProfile2State extends State<StaffProfile2> {
  final GlobalKey<FormState> form_editProfile = GlobalKey<FormState>();
  var staffPhoneNo;
  var staffEmail;
  var staffUsername;
  var staffName;
  var imgURL;
  File? pickedImage;
  FirebaseAuth auth = FirebaseAuth.instance;
  var PNController = TextEditingController();
  var nameController = TextEditingController();
  var updateName;
  var updateEmail;
  var updatePhoneNp;

  updateUserNameAndPhone(String name, String phoneNo) async {
    final fbUser = FirebaseAuth.instance.currentUser!;
    await FirebaseDatabase.instance
        .reference()
        .child('Staff')
        .child(fbUser.uid)
        .update({
      'phone-number': phoneNo,
      'name': name,
    });
  }

  updateUserDataPhoneNo(String phoneNo) async {
    final fbUser = FirebaseAuth.instance.currentUser!;
    await FirebaseDatabase.instance
        .reference()
        .child('Staff')
        .child(fbUser.uid)
        .update({
      'phone-number': phoneNo,
    });
  }

  updateUserDataName(String name) async {
    final fbUser = FirebaseAuth.instance.currentUser!;
    await FirebaseDatabase.instance
        .reference()
        .child('Staff')
        .child(fbUser.uid)
        .update({
      'name': name,
    });
  }

  ////save user picture in firebase storage
  saveUserPicture() async {
    final auth = FirebaseAuth.instance.currentUser;
    String imgURL = "";
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    String fileName = basename(pickedImage!.path);
    FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;
    Reference ref =
        firebaseStorageRef.ref().child('upload/$userEmail/$fileName.jpg');
    UploadTask task = ref.putFile(pickedImage!);
    TaskSnapshot snapshot = await task;
    imgURL = await snapshot.ref.getDownloadURL();

    ////save img url to user real-time database
    FirebaseDatabase.instance
        .reference()
        .child('Staff')
        .child(auth!.uid)
        .update({
      'profile-pictureURL': imgURL,
    });
  }

///// get user info
  fetchUserData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    await FirebaseDatabase.instance
        .reference()
        .child('Staff')
        .child(firebaseUser!.uid)
        .once()
        .then((DataSnapshot snapshot) {
      staffName = snapshot.value['name'].toString();
      staffUsername = snapshot.value['username'].toString();
      staffEmail = snapshot.value['email'].toString();
      staffPhoneNo = snapshot.value['phone-number'].toString();
      imgURL = snapshot.value['profile-pictureURL'];
    }).catchError((e) {
      print(e);
    });
  }

  ///get image
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
          //centerTitle: true,
          title: Text('Profile'),
          backgroundColor: Color(0xff900C3F),
          actions: [
            TextButton(
                onPressed: () {
                  saveUserPicture();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            //title: Text(''),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('Your picture has been save.')
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Okay'))
                            ]);
                      });
                },
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              //color: Colors.amberAccent,
              // gradient: LinearGradient(
              //   colors: [Colors.white24, new Color(0xff900C3F)],
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              // ),
              ),
          child: FutureBuilder(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading data...Please wait");
              } else if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(20),
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 50, left: 10, right: 10)),
                  Container(
                    child: Column(
                      children: <Widget>[
                        pickedImage != null
                            ? ClipOval(
                                child: Image.file(
                                  pickedImage!,
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipOval(
                                child: Image.network(
                                imgURL,
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              )),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  //////user profile picture
                  Container(
                    child: Column(
                      children: <Widget>[
                        ElevatedButton.icon(
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          label: Text('Upload picture'),
                          icon: Icon(Icons.upload),
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Colors.red.shade900),
                        )
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(""),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    color: Colors.white,
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          if (states
                              .contains(MaterialStateMouseCursor.textable))
                            return Colors.transparent;
                          if (states.contains(MaterialState.focused))
                            return Colors.red;
                          if (states.contains(MaterialState.hovered))
                            return Colors.transparent;
                          if (states.contains(MaterialState.pressed))
                            return Colors.blue;
                          return Colors.red
                              .shade900; // null throus error in flutter 2.2+.
                        }),
                      ),
                      onPressed: () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()),
                        );
                      },
                      child: Text('Edit profile'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    color: Colors.white,
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    color: Colors.white,
                    child: Text(
                      staffName,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  //////////USERNAME
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    color: Colors.white,
                    child: Text(
                      'Staff ID',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    color: Colors.white,
                    child: Text(
                      staffUsername,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  //////////EMAIL
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    color: Colors.white,
                    child: Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //////////EMAIL
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    color: Colors.white,
                    child: Text(
                      staffEmail,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  //////////CONTACT
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    color: Colors.white,
                    child: Text(
                      'Contact ',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //////////CONTACT
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    color: Colors.white,
                    child: Text(
                      staffPhoneNo,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(""),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    child: Column(
                      children: <Widget>[
                        ElevatedButton.icon(
                          onPressed: () {
                            auth.signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          label: Text('Logout'),
                          icon: Icon(Icons.logout),
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Colors.red.shade900),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
