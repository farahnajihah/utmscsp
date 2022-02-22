import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:utmscsm_app/scstaff/scstaffprofile.dart';


class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> form_editProfile = GlobalKey<FormState>();
  var updateName;
  var updateEmail;
  var updatePhoneNp;

  var staffName, staffUsername, staffEmail, staffPhoneNo;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var PNController = TextEditingController();

  fetchUserData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    await FirebaseDatabase.instance
        .reference()
        .child('Staff')
        .child(firebaseUser.uid)
        .once()
        .then((DataSnapshot snapshot) {
      staffName = snapshot.value['name'];
      staffEmail = snapshot.value['email'];
      staffPhoneNo = snapshot.value['phone-number'];
    }).catchError((e) {
      print(e);
    });
  }

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

  @override
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StaffProfile2()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        //backgroundColor: Colors.transparent,
        backgroundColor: Color(0xff900C3F),

        ///automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                // signOut();
              },
              icon: Icon(Icons.logout))
        ],
        centerTitle: true,
        title: Text(
          "Edit profile",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white24
          // gradient: LinearGradient(
          //   colors: const [Colors.white24, Color(0xff900C3F)],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: FutureBuilder(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Something went wrong!')));
                //return Text('Something went wrong');
              }
              //staffName = nameController.text;
              return Form(
                key: form_editProfile,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: <Widget>[
                    //////UPDATE NAME
                    Container(
                      padding: EdgeInsets.only(top: 80),
                      child: TextFormField(
                        controller: nameController,
                        onChanged: (value) {
                          setState(() {
                            updateName = value;
                          });
                        },
                        autofocus: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: staffName,
                          labelText: 'Name',
                          labelStyle: TextStyle(fontStyle: FontStyle.italic),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Colors.red.shade900)),
                        ),
                      ),
                    ),
                    //////UPDATE PHONE NO
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: PNController,
                        onChanged: (value) {
                          setState(() {
                            updatePhoneNp = value;
                          });
                        },
                        autofocus: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: staffPhoneNo,
                          labelText: 'Phone number',
                          labelStyle: TextStyle(fontStyle: FontStyle.italic),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Colors.red.shade900)),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, right: 40, left: 40),
                      child: ElevatedButton(
                        onPressed: () {
                          final FormState? _form2 =
                              form_editProfile.currentState;
                          if (_form2!.validate() &&
                              nameController.text.isNotEmpty &&
                              PNController.text.isEmpty) {
                            updateUserDataName(nameController.text);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StaffProfile2()));
                          } else if (_form2.validate() &&
                              nameController.text.isEmpty &&
                              PNController.text.isNotEmpty) {
                            updateUserDataPhoneNo(PNController.text);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StaffProfile2()));
                          } else if (_form2.validate() &&
                              nameController.text.isNotEmpty &&
                              PNController.text.isNotEmpty) {
                            updateUserNameAndPhone(
                                nameController.text, PNController.text);
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StaffProfile2()));
                          }
                        },
                        child: Text('Save'),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          primary: Color(0xff900C3F),
                          fixedSize: Size(40, 50),
                          //padding: const EdgeInsets.symmetric( horizontal: 60,vertical: 15),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
