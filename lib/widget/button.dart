import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  //const MyButton({Key? key}) : super(key: key);
  final Function()? onPressed;
  final String name;
  Button({required this.name, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Text(name),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(40, 50),
          textStyle: const TextStyle(fontSize: 20),
          primary: Color(0xff900C3F),
          shape: StadiumBorder(),
          ),
          onPressed: onPressed,
        ),
    );
  }
}
