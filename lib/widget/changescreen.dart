import 'package:flutter/material.dart';

class ChangeScreen extends StatelessWidget {
  //const ChangeScreen({Key? key}) : super(key: key);
  final String whichAccount;
  final String name;
  final Function()? onTap;
  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  ChangeScreen(
      {required this.name, required this.onTap, required this.whichAccount});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20)),
          Text(whichAccount, style: TextStyle(fontSize: 15),),
          SizedBox(width: 10),
          GestureDetector(
            onTap: onTap,
            child: Text(name, style: TextStyle(fontSize: 15, color: Colors.red.shade900, fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }
}
