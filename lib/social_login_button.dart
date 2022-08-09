import 'package:flutter/material.dart';
import 'package:yuru_kazan_app/email_login.dart';
import 'package:yuru_kazan_app/main.dart';
// ignore_for_file: prefer_const_constructors

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {required this.buttonText,
      required this.buttonColor,
      required this.textColor,
      required this.radius,
      required this.buttonIcon,
      required this.onPressed})
      : assert(buttonText != null);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(color: textColor),
      ),
      color: buttonColor,
    );
  }
}
