import 'package:flutter/material.dart';

class TerminalMainText extends StatelessWidget {
  final String mainText;
  final String commandText;

  TerminalMainText({
    @required this.mainText,
    @required this.commandText
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 11.5,
        ),
        children: [
          TextSpan(
            text: '$mainText',
            style: TextStyle(
                color: Color.fromRGBO(136, 230, 52, 1),
                fontWeight: FontWeight.bold,
                fontFamily: 'ITC'),
          ),
          TextSpan(
            text: '/my_rooms',
            style: TextStyle(
              color: Color.fromRGBO(119, 170, 208, 1),
              fontFamily: 'ITC',
            ),
          ),
          TextSpan(
            text: ' \$ $commandText',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'ITC',
            ),
          ),
        ],
      ),
    );
  }
}
