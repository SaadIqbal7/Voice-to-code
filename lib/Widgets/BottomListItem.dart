import 'package:flutter/material.dart';

class BottomListItem extends StatelessWidget {
	final String text;
	final Color color;
	final Function operation;
	final String op;

	BottomListItem({ @required this.operation, @required this.text, @required this.color, this.op='default' });

	@override
	Widget build(BuildContext context) {
		return Row(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: <Widget>[
				ButtonTheme(
					child: FlatButton(
						child: Text(
							this.text,
							style: TextStyle(
								fontSize: 16,
								fontWeight: FontWeight.bold,
								color: this.color
							),
						),
						color: Color.fromRGBO(10, 10, 10, 0.1),
						onPressed: (){
							operation(op=='default'? this.text:this.op);
						},
					),
				),
				VerticalDivider(
					width: 1,
				)
			],
		);
	}
}