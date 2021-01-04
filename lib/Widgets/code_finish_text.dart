import 'package:flutter/material.dart';


class CodeBlockText extends StatelessWidget {
  final double fontSize;
  final String text;
  final double letterSpacing;

  CodeBlockText({this.text, this.fontSize, this.letterSpacing});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontFamily: 'ITC', letterSpacing: letterSpacing, fontSize: fontSize),
        children: [
          TextSpan(
            text: '<\\',
            style: TextStyle(
              color: Colors.red[500],
            ),
          ),
          TextSpan(
            text: '$text',
            style: TextStyle(
              color: Colors.green[500],
            ),
          ),
          TextSpan(text: '>', style: TextStyle(color: Colors.red[500]))
        ],
      ),
    );
  }
}
