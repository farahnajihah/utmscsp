// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utmscsm_app/scstaff/stafflogin.dart';
import 'package:utmscsm_app/widget/changescreen.dart';
import 'package:utmscsm_app/widget/button.dart';

import 'adminhomepage.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  var email, password;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  validation() async {
    final FormState? _form = _formKey2.currentState;
    if (_form!.validate()) {
      try {
        UserCredential userid = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Successful sign in')));
        return userid.user;
      } on PlatformException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()),
        ));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Colors.white24,
          gradient: LinearGradient(
            colors: const [Colors.white24, Color(0xffC50000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey2,
          child: ListView(
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(30.0)),
              Image(
                image: AssetImage('assets/logo.png'),
                width: 200.0,
                height: 200.0,
              ),

              SizedBox(height: 20),
              Text(
                'Admin',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              //EMAIL FORMFIELD
              Padding(padding: const EdgeInsets.all(10.0)),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (staffuser) {
                  if (staffuser == null || staffuser.isEmpty) {
                    return 'Please enter your email';
                  }
                },
                controller: emailController,
                style: TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.account_circle,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.red.shade900)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(color: Colors.red.shade900)),
                  labelText: 'Email',
                ),
              ),

              //PASSWORD FORMFIELD
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                validator: (pass) {
                  if (pass == null || pass.isEmpty) {
                    return 'Please enter your password';
                  }
                },
                controller: passwordController,
                obscureText: true,
                style: TextStyle(fontSize: 17.0),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.vpn_key,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.red.shade900)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(color: Colors.red.shade900)),
                  labelText: 'Password',
                  //border: OutlineInputBorder(),
                ),
              ),
              // ignore: unnecessary_new
              SizedBox(
                height: 20,
              ),
              
              Button(
                onPressed: () {
                  if (emailController.text == 'admin-sc@gmail.com' &&
                      passwordController.text == 'admin123') {
                    validation();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Wrong email! Please use correct email.')));
                  }
                },
                name: "Sign in as Admin",
              ),

              ///////changescreen
              Padding(padding: EdgeInsets.only(top:10)),
              ChangeScreen(
                  name: "Staff",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  whichAccount: "Sign in as")
            ],
          ),
        ),
      ),
    );
  }
}
