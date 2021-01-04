import 'package:flutter/material.dart';

class TerminalTopIcon extends StatelessWidget {
  final IconData icon;
  final Color backColor;
  final Color iconColor;

  TerminalTopIcon({
    @required this.icon,
    @required this.backColor,
    @required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
      child: Icon(
        icon,
        color: iconColor,
        size: 10,
      ),
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
