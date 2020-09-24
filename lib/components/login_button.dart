import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Function onTap;

  LoginButton({this.text, this.textColor, this.backgroundColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
