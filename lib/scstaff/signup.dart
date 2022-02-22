// // ignore_for_file: prefer_const_constructors

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/services.dart';
// import 'package:utmscsm_app/scstaff/verify.dart';
// import 'package:utmscsm_app/widget/changescreen.dart';
// import 'package:utmscsm_app/widget/mybutton.dart';
// import 'stafflogin.dart';

// // ignore: must_be_immutable
// class SignUp extends StatefulWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   SignUp({Key? key}) : super(key: key);

//   @override
//   _SignUpState createState() => _SignUpState();
//   bool obserText = true;
// }

// class _SignUpState extends State<SignUp> {
//   late String email;
//   late String password;
//   final databaseRef = FirebaseDatabase.instance.reference();
//   final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   void addUser(String name, String username, String email, String phoneNo,
//       String password, String confirmpass) async {
//     final FormState? _form = _formKey2.currentState;
//     if (_form!.validate()) {
//       try {
//         UserCredential result = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(email: email, password: password);
//         FirebaseFirestore.instance
//             .collection("Staff")
//             .doc(result.user!.uid)
//             .set({
//           'name': name,
//           'userID': result.user!.uid,
//           'username': username,
//           'email': email,
//           'phone-number': phoneNo,
//           'password': password,
//           'confirm-password': confirmpass,
//         });
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("Successful register!")));
//       } on PlatformException catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(e.message.toString()),
//         ));
//       }
//     } else {
//       // ignore: avoid_print
//       print("No");
//     }
//   }

//   var signUpNameController = TextEditingController();
//   var emailController = TextEditingController();
//   var staffIDController = TextEditingController();
//   var phoneNumberController = TextEditingController();
//   var passwordSUController = TextEditingController();
//   var confirmSUController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       resizeToAvoidBottomInset: false,
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(30.0),
//         child: Form(
//           key: _formKey2,
//           child: Column(
//             children: <Widget>[
//               Padding(padding: const EdgeInsets.all(30.0)),
//               Text(
//                 "Sign Up",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 30.0,
//                   color: Colors.purple,
//                 ),
//               ),

//               //NAME FORMFIELD

//               Padding(padding: const EdgeInsets.all(10.0)),
//               SizedBox(
//                 height: 15.0,
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name';
//                   }
//                   return null;
//                 },
//                 autofocus: false,
//                 controller: signUpNameController,
//                 style: TextStyle(fontSize: 17.0),
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(
//                     Icons.account_circle,
//                   ),
//                   filled: true,
//                   fillColor: Colors.black12,
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20.0),
//                       ),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   labelText: 'Full Name',
//                 ),
//                 onChanged: (val) {},
//               ),

//               //EMAIL FORMFIELD
//               SizedBox(
//                 height: 15.0,
//               ),
//               TextFormField(
//                 onChanged: (value) {
//                   setState(() {
//                     email = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//                 autofocus: false,
//                 controller: emailController,
//                 style: TextStyle(fontSize: 17.0),
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(
//                     Icons.mail,
//                   ),
//                   filled: true,
//                   fillColor: Colors.black12,
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20.0),
//                       ),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   labelText: 'E-mail',
//                 ),
//               ),

//               //STADD ID FORMFIELD
//               SizedBox(
//                 height: 20.0,
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your staff ID';
//                   }
//                   return null;
//                 },
//                 autofocus: false,
//                 controller: staffIDController,
//                 style: TextStyle(fontSize: 17.0),
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(
//                     Icons.account_box_rounded,
//                   ),
//                   filled: true,
//                   fillColor: Colors.black12,
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20.0),
//                       ),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   labelText: 'Staff ID',
//                 ),
//                 onChanged: (val) {},
//               ),

//               //PHONENUMBER FORMFIELD
//               SizedBox(
//                 height: 20.0,
//               ),
//               TextFormField(
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   return null;
//                 },
//                 autofocus: false,
//                 controller: phoneNumberController,
//                 style: TextStyle(fontSize: 17.0),
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(
//                     Icons.phone_android,
//                   ),
//                   filled: true,
//                   fillColor: Colors.black12,
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20.0),
//                       ),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   labelText: 'Phone Number',
//                 ),
//                 onChanged: (val) {},
//               ),

//               //PASSWORD FORMFIELD
//               SizedBox(
//                 height: 15.0,
//               ),
//               TextFormField(
//                 onChanged: (value) {
//                   setState(() {
//                     password = value;
//                   });
//                 },
//                 validator: (passvalue) {
//                   if (passvalue == null || passvalue.isEmpty) {
//                     return 'Please enter your password';
//                   } else if (passvalue.length < 8) {
//                     return 'Please enter a password with at least 8 characters';
//                   } else {
//                     return null;
//                   }
//                 },
//                 autofocus: false,
//                 controller: passwordSUController,
//                 obscureText: true,
//                 style: TextStyle(fontSize: 17.0),
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(
//                     Icons.vpn_key,
//                   ),
//                   filled: true,
//                   fillColor: Colors.black12,
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20.0),
//                       ),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   labelText: 'Password',
//                   //border: OutlineInputBorder(),
//                 ),
//               ),

//               //CONFIRMPASSWORD FORMFIELD
//               SizedBox(
//                 height: 15.0,
//               ),
//               TextFormField(
//                 validator: (confirmpassvalue) {
//                   if (confirmpassvalue == null || confirmpassvalue.isEmpty) {
//                     return 'Please re-enter your password ';
//                   } else if (confirmpassvalue.length < 8) {
//                     return 'Please enter a password with at least 8 characters';
//                   } else if (confirmpassvalue != passwordSUController.text) {
//                     return 'Your password does not match';
//                   }
//                   return null;
//                 },
//                 autofocus: false,
//                 controller: confirmSUController,
//                 obscureText: true,
//                 style: TextStyle(fontSize: 17.0),
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(
//                     Icons.vpn_key,
//                   ),
//                   filled: true,
//                   fillColor: Colors.black12,
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20.0),
//                       ),
//                       borderSide: BorderSide(color: Colors.white70)),
//                   labelText: 'Confirm-Password',
//                   //border: OutlineInputBorder(),
//                 ),
//                 onChanged: (val) {},
//               ),
//               // ignore: unnecessary_new
//               SizedBox(
//                 height: 20,
//               ),
//               MyButton(
//                 name: "Sign Up",
//                 onPressed: () {
//                   if (_formKey2.currentState!.validate()) {
//                     try {
//                       addUser(
//                           signUpNameController.text,
//                           staffIDController.text,
//                           emailController.text,
//                           phoneNumberController.text,
//                           passwordSUController.text,
//                           confirmSUController.text);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => VerifyEmail()),
//                       );
//                     } on PlatformException catch (e) {
//                       return e.message.toString();
//                     }
//                   }
//                 },
//               ),
//               ChangeScreen(
//                   name: "Sign In",
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => Login()),
//                     );
//                   },
//                   whichAccount: "I already have an account?"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void addUserData(String text, String text2, String text3, String text4,
//       String text5, String text6) {}
// }
