import 'package:flutter/material.dart';
import 'package:python_text_editor/Widgets/code_finish_text.dart';


class RegisterTextField extends StatelessWidget {
  final TextEditingController controller;
  final CodeBlockText codeBlockText;
  final TextInputType keyboardType;
  final bool obscureText;

  RegisterTextField({this.controller, this.codeBlockText, this.keyboardType, this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.black, fontSize: 13, letterSpacing: 1, fontFamily: 'ITC'),
      obscureText: obscureText,
      cursorColor: Colors.green[600],
      cursorWidth: 5,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green[500], width: 2)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green[500], width: 2)),
        prefix: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            codeBlockText,
            SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
  }
}
