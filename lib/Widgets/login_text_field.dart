import 'package:flutter/material.dart';


class LoginTextField extends StatelessWidget {
  final String attributeText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;

  LoginTextField({this.controller, this.attributeText, this.keyboardType, this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.green[600],
      cursorWidth: 5,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        fontFamily: 'ITC',
        fontSize: 13,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green[500], width: 2)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green[500], width: 2)),
        prefix: RichText(
          text: TextSpan(
            style: TextStyle(fontFamily: 'ITC', fontSize: 13, letterSpacing: 1.1),
            children: [
              TextSpan(
                text: '<',
                style: TextStyle(
                  color: Colors.red[500],
                ),
              ),
              TextSpan(
                text: '$attributeText="',
                style: TextStyle(
                  color: Colors.green[500],
                ),
              )
            ],
          ),
        ),
        suffix: RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'ITC',
              fontSize: 13,
              letterSpacing: 1.0
            ),
            children: [
              TextSpan(
                text: '"',
                style: TextStyle(
                  color: Colors.green[500],
                ),
              ),
              TextSpan(
                text: '/>',
                style: TextStyle(
                  color: Colors.red[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
