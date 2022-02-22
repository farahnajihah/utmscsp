import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:utmscsm_app/scstaff/register.dart';
import 'package:utmscsm_app/scstaff/homepage.dart';
import 'package:utmscsm_app/admin/adminlogin.dart';
import 'package:utmscsm_app/scstaff/resetpassword.dart';
import 'package:utmscsm_app/widget/changescreen.dart';
import '../widget/button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ///final dataRef = FirebaseDatabase.instance.reference().child("Staff");
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  late String email;
  late String password;
  var emailStaff, passwordStaff, iduser;
  final dataref = FirebaseDatabase.instance.reference().child('Staff');
  final auth = FirebaseAuth.instance.currentUser;

  Future validation() async {
    final FormState? _form = _formKey2.currentState;
    await dataref.once().then((DataSnapshot snapshot) {
      emailStaff = snapshot.value['email'];
    });
    if (_form!.validate()) {
      try {
        UserCredential userid = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        if (userid.user!.emailVerified == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => homePage()),
          ); //route to homepage
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Please verify your email.'),
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
        }
        return userid.user;
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Incorrect email or password.'),
                      //Text('Please register'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay')),
                  // TextButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => Register()),
                  //       );
                  //     },
                  //     child: Text('Create an account')),
                ],
              );
            });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong.')));
    }
  }

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

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
                  } else if (pass != password) {
                    return 'Wrong password';
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
                  validation();
                },
                name: "Sign in as Staff",
              ),

              ///////changescreen
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ResetPassword()));
                  },
                  child: Text('Forgot password?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 15))),
              ChangeScreen(
                  name: "Sign Up",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  whichAccount: "Do not have an account?"),

              ChangeScreen(
                  name: "Admin",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminLogin()),
                    );
                  },
                  whichAccount: "Sign in as"),
              Padding(padding: EdgeInsets.only(top: 30)),
              
            ],
          ),
        ),
      ),
    );
  }

  void signInwithEmailAndPassword(String text, String text2) {}
}
