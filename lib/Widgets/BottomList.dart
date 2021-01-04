import 'package:flutter/material.dart';
import 'package:python_text_editor/Widgets/BottomListItem.dart';
import 'dart:math';


class BottomToolsList extends StatelessWidget {

	final List<BottomListItem> bottomListItems = [];
	final Random random = Random();
	final Function operation;

	final List<Color> poolOfColors = [
		Colors.pink[200],
		Colors.green[200],
		Colors.purple[200],
		Colors.yellow[200],
		Colors.amber,
		Colors.blue[200],
		Colors.indigo[200],
		Colors.brown[100],
		Colors.red[300]
	];


	BottomToolsList( {@required this.operation });

	void makeList(){
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: 'Tab', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
				op: '\t' // 4 Spaces
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '(', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: ')', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '\'', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: ':', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: 'def', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: 'class', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '"', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '{', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '}', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '[', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: ']', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: ',', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '=', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '+', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '!', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '/', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '.', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: ';', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '<', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '>', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: 'and', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: 'or', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '&', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '|', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '*', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '+', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '-', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '%', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '_', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '@', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '?', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
		bottomListItems.add(
			BottomListItem(
				operation:this.operation, 
				text: '^', color: 
				poolOfColors[random.nextInt(poolOfColors.length)],
			)
		);
	}

	@override
	Widget build(BuildContext context) {
		makeList();
		return Positioned(
			child: Container(
				height: 45,
				child: ListView(
					shrinkWrap: true,
					scrollDirection: Axis.horizontal,
					children: bottomListItems
				),
			),
			bottom: 0.0,
			left: 0.0,
			right: 0.0,
		);
	}
}