import 'package:flutter/material.dart';

class AuthRouteBottomText extends StatelessWidget {
  final String rightSideText;
  final String leftSideText;
  final Function navigate;

  AuthRouteBottomText(this.rightSideText, this.leftSideText, this.navigate);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$rightSideText',
          style: TextStyle(
            color: Colors.grey[500],
          ),
        ),
        ButtonTheme(
          padding: EdgeInsets.all(3),
          height: 0,
          minWidth: 0,
          child: FlatButton(
            child: Text('$leftSideText'),
            onPressed: () {
              navigate();
            },
          ),
        ),
      ],
    );
  }
}
