import 'package:flutter/material.dart';


class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function callback;


  NavBarItem({this.icon, this.text, this.callback});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        child: Container(
          height: 60,
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              Icon(
                icon,
                color: Colors.black,
                size: 30,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '$text',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12
                ),
              )
            ],
          ),
        ),
        onPressed: callback,
      ),
    );
  }
}