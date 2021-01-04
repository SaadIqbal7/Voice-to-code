import 'package:flutter/material.dart';

class SubLogoText extends StatelessWidget {
	final String _startText;

	SubLogoText(this._startText);
	
	@override
	Widget build(BuildContext context) {
		return Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: <Widget>[
				Text(
					this._startText,
					style: TextStyle(
						color: Colors.grey[500],
						fontFamily: 'ITC',
					),
				),
				SizedBox(
					width: 7,
				),
				Text(
					'Be',
					style: TextStyle(
						color: Colors.black,
						fontFamily: 'ITC',
					),
				),
				Icon(
				  	Icons.arrow_downward,
				  	size: 18,
				  ),
				Text(
					'ow',
					style: TextStyle(
						color: Colors.black,
						fontFamily: 'ITC',
					),
				),
			],
		);
	}
}
