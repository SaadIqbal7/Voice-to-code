import 'package:flutter/material.dart';
import 'package:python_text_editor/Widgets/code_finish_text.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: TextStyle(
                fontFamily: 'ITC',
                fontSize: 20,
                letterSpacing: 1.8,
                color: Colors.black),
            children: [
              TextSpan(
                text: 'Voice',
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
          child: Text(
            'to',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'ITC',
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        CodeBlockText(
          text: 'code',
          fontSize: 20,
          letterSpacing: 1.8,
        ),
      ],
    );
  }
}
