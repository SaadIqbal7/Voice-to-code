import 'package:flutter/material.dart';
import 'package:python_text_editor/Widgets/terminal_top_icon.dart';

class TerminalTopBar extends StatelessWidget {
  final String mainText;
  final double height;
  final double mainTextSize;

  TerminalTopBar({
    @required this.mainText,
    @required this.mainTextSize,
    @required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Color.fromRGBO(82, 80, 72, 1),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(4),
          topLeft: Radius.circular(4),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Text(
                  '$mainText',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'ITC',
                    fontSize: mainTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          TerminalTopIcon(
            icon: Icons.minimize,
            backColor: Color.fromRGBO(124, 127, 119, 1),
            iconColor: Color.fromRGBO(95, 93, 87, 1),
          ),
          TerminalTopIcon(
            icon: Icons.check_box_outline_blank,
            backColor: Color.fromRGBO(124, 127, 119, 1),
            iconColor: Color.fromRGBO(95, 93, 87, 1),
          ),
          TerminalTopIcon(
            icon: Icons.add,
            backColor: Color.fromRGBO(222, 81, 36, 1),
            iconColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
