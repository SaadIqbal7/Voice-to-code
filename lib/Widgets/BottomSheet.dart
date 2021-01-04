import 'package:flutter/material.dart';

class OutputBottomSheet extends StatelessWidget {
	final String _text;

	OutputBottomSheet(this._text);
	@override
	Widget build(BuildContext context) {
		return Container(
			color: Colors.grey[850],
		  child: Column(
				mainAxisSize: MainAxisSize.min,
				crossAxisAlignment: CrossAxisAlignment.stretch,
		  	children: <Widget>[
		  		Container(
		  			child: Text(
		  				'Output',
		  				style: TextStyle(
		  					color: Colors.green[500],
								fontSize: 16,
								fontWeight: FontWeight.bold,
		  				)
		  			),
		  			padding: EdgeInsets.all(10),
		  			decoration: BoxDecoration(
		  				border: Border(
		  					bottom: BorderSide(
		  						color: Colors.grey[500],
		  						width: 1
		  					)
		  				)
		  			),
		  		),
					Container(
						padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
						child: Text(
							this._text,
		  				style: TextStyle(
		  					color: Colors.grey[400],
								fontSize: 15
		  				)
						),
					)
		  	],
		  ),
		);
	}
}