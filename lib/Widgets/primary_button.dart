import 'package:flutter/material.dart';


class PrimaryButton extends StatelessWidget {
  final String text;
  final Function callback;
  PrimaryButton({this.text, this.callback});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        '$text',
        style: TextStyle(color: Colors.white, fontFamily: 'ITC', fontSize: 15),
      ),
      color: Colors.green[400],
      onPressed: callback
    );
  }
}
