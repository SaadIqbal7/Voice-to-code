import 'package:flutter/material.dart';

class CreateRoomTerminalDialogTextField extends StatelessWidget {
  final TextEditingController controller;
  final Widget child;

  CreateRoomTerminalDialogTextField({@required this.child, @required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        child,
        Container(
          height: 50,
          width: 200,
          child: TextField(
            controller: this.controller,
            cursorColor: Colors.white,
            cursorWidth: 5,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontFamily: 'ITC'
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
