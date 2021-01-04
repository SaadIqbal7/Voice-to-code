import 'package:flutter/material.dart';

class ListViewTerminalColumn extends StatelessWidget {
  final String heading;
  final String text;

  ListViewTerminalColumn({this.heading, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$heading',
          style:
              TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'ITC'),
        ),
        Text(
          '$text',
          style:
              TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'ITC'),
        )
      ],
    );
  }
}
