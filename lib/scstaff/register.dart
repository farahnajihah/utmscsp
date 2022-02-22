///REGISTER REALTIME
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utmscsm_app/scstaff/stafflogin.dart';
import 'package:utmscsm_app/widget/changescreen.dart';
import 'package:utmscsm_app/widget/button.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String email;
  late String password;
  final databaseRef = FirebaseDatabase.instance.reference();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var image = 'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg';
  int count = 0;

  ////ADD USER DATA
  void addUser(
      String name, String username, String email, String phoneNo) async {
        
    final FormState? _form = _formKey2.currentState;
    if (_form!.validate()) {
      try {
        ////create user auth account
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await result.user!.sendEmailVerification();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Verification Email'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('An email verification has been sent to $email'),
                      Text('Please verify before login to the application.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text('Okay, I get it.')),
                ],
              );
            });

        FirebaseDatabase.instance
            .reference()
            .child('Staff')
            .child(result.user!.uid)
            .set({
          'name': name,
          'userID': result.user!.uid,
          'username': username,
          'email': email,
          'phone-number': phoneNo,
          'profile-pictureURL':image,
          'mail-status':count,
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Successful register!")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'This email is already registered. Please use another email.'),
        ));
      }
    } else {
      // ignore: avoid_print
      print("No");
    }
  }

  var signUpNameController = TextEditingController();
  var emailController = TextEditingController();
  var staffIDController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var passwordSUController = TextEditingController();
  var confirmSUController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Form(
          key: _formKey2,
          child: ListView(
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(30.0)),
              Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.red.shade900,
                ),
              ),

              //NAME FORMFIELD

              Padding(padding: const EdgeInsets.all(10.0)),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                autofocus: false,
                controller: signUpNameController,
                style: TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.account_circle,
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(color: Colors.white70)),
                  labelText: 'Full Name',
                ),
                onChanged: (val) {},
              ),

              //EMAIL FORMFIELD
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                autofocus: false,
                controller: emailController,
                style: TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.mail,
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(color: Colors.white70)),
                  labelText: 'E-mail',
                ),
              ),

              //STADD ID FORMFIELD
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your staff ID';
                  }
                  return null;
                },
                autofocus: false,
                controller: staffIDController,
                style: TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.account_box_rounded,
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(color: Colors.white70)),
                  labelText: 'Staff ID',
                ),
                onChanged: (val) {},
              ),

              //PHONENUMBER FORMFIELD
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                autofocus: false,
                controller: phoneNumberController,
                style: TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.phone_android,
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(color: Colors.white70)),
                  labelText: 'Phone Number',
                ),
                onChanged: (val) {},
              ),

              //PASSWORD FORMFIELD
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                validator: (passvalue) {
                  if (passvalue == null || passvalue.isEmpty) {
                    return 'Please enter your password';
                  } else if (passvalue.length < 8) {
                    return 'Please enter a password with at least 8 characters';
                  } else {
                    return null;
                  }
                },
                autofocus: false,
                controller: passwordSUController,
                obscureText: true,
                style: TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.vpn_key,
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(color: Colors.white70)),
                  labelText: 'Password',
                  //border: OutlineInputBorder(),
                ),
              ),

              //CONFIRMPASSWORD FORMFIELD
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                validator: (confirmpassvalue) {
                  if (confirmpassvalue == null || confirmpassvalue.isEmpty) {
                    return 'Please re-enter your password ';
                  } else if (confirmpassvalue.length < 8) {
                    return 'Please enter a password with at least 8 characters';
                  } else if (confirmpassvalue != passwordSUController.text) {
                    return 'Your password does not match';
                  }
                  return null;
                },
                autofocus: false,
                controller: confirmSUController,
                obscureText: true,
                style: TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.vpn_key,
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.white70)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(color: Colors.white70)),
                  labelText: 'Confirm-Password',
                  //border: OutlineInputBorder(),
                ),
                onChanged: (val) {},
              ),
              // ignore: unnecessary_new
              SizedBox(
                height: 20,
              ),
              Button(
                name: "Sign Up",
                onPressed: () {
                  if (_formKey2.currentState!.validate()) {
                    try {
                      addUser(
                        signUpNameController.text,
                        staffIDController.text,
                        emailController.text,
                        phoneNumberController.text,
                      );
                    } on PlatformException catch (e) {
                      return e.message.toString();
                    }
                  }
                },
              ),
              ChangeScreen(
                  name: "Sign In",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  whichAccount: "I already have an account?"),
            ],
          ),
        ),
      ),
    );
  }
}
