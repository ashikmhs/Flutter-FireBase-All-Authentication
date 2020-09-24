import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextInputType keyboardtype;
  final Function onChange;

  Textfield({this.icon, this.text, this.keyboardtype, this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChange,
      style: TextStyle(color: Colors.white),
      keyboardType: keyboardtype,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.grey[300]),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.grey[300]),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey[300],
        ),
        hintText: text,
        hintStyle: TextStyle(color: Colors.grey[300]),
      ),
    );
  }
}
