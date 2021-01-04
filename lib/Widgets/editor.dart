import 'package:flutter/material.dart';
import 'package:python_text_editor/utilities/pusher_api.dart';


class Editor extends StatefulWidget {
	final TextEditingController mainController;
	final TextEditingController sideBarController;
	final PusherApi pusherApi;

	Editor(this.mainController, this.sideBarController, this.pusherApi);

	@override
	_EditorState createState() => _EditorState(mainController: mainController, sideBarController: sideBarController);
}

class _EditorState extends State<Editor> {

	final TextEditingController mainController;
	final TextEditingController sideBarController;

	_EditorState({this.mainController, this.sideBarController});

	String replaceCharAt(String oldString, int index, String newChar) {
		return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
	}

	void changeLineNumber(String lineNumberText, String editorText) {
		// Extract the last number(1,2 or 3 digit number)
		// Check if the last number is 1 2 or 3 digit
		int counter = 0;
		StringBuffer reverseNumber = StringBuffer('');
		for(int i = lineNumberText.length-2; i >= 0 && lineNumberText[i] != '\n'; i--) {
			reverseNumber.write(lineNumberText[i]);
			counter++;
		}
		// Reverse the number string to get the original number;
		StringBuffer number = StringBuffer('');
		for(int i = counter - 1; i >= 0; i--) {
			number.write(reverseNumber.toString()[i]);
		}
	
		if(editorText.endsWith('\n')) {
			int numberOfNewLineCharacters = '\n'.allMatches(editorText).length + 1;
			int sideBarLineNumber = int.parse(number.toString());
			if(numberOfNewLineCharacters > sideBarLineNumber) {        
				StringBuffer sideBarBuffer = StringBuffer(sideBarController.text);

				if(numberOfNewLineCharacters - sideBarLineNumber > 1) {
					for(int i = sideBarLineNumber + 1; i < numberOfNewLineCharacters; i++) {
						sideBarBuffer.write(i.toString() + '\n');
					}
				}
				sideBarBuffer.write(numberOfNewLineCharacters.toString() + '\n');
				sideBarController.text = sideBarBuffer.toString();
			} else if(numberOfNewLineCharacters < sideBarLineNumber) {
				sideBarController.text = sideBarController.text.substring(0, sideBarController.text.length - 1 - counter);
			}
		}
	}

  Function callback;

	void bindToChannel(PusherApi pusherApi) {
    pusherApi.bindEvent('client-edit-text', getDataFromPusherClient);
	}

  void getDataFromPusherClient(String data) {
    setState(() {
      callback = null;
    });
    mainController.text = data;
    setState(() {
      callback = triggerEvent;
    });
  }

	void triggerEvent(String text) {
		widget.pusherApi.triggerEvent('client-edit-text', text);
	}

  @override
  void initState() {
    bindToChannel(widget.pusherApi);
    callback = triggerEvent;
    super.initState();
  }

	@override
	Widget build(BuildContext context) {
		sideBarController.text = '1\n';

		return ListView(
			children: <Widget>[
				Row(
					children: <Widget>[
						Container(
							decoration: BoxDecoration(
								border: Border(
									right: BorderSide(width: 1.0, color: Colors.green[500])
								)
							),
							width: 35,
							child: Padding(
								padding: const EdgeInsets.fromLTRB(3, 5, 0, 5),
								child: TextField(
									controller: sideBarController,
									decoration: InputDecoration(
										border: InputBorder.none
									),
									minLines: 30,
									maxLines: 1000,
									style: TextStyle(
										color: Colors.grey[600],
										fontSize: 14,
									),
									enabled: false,
								),
							),
						),
						Expanded(
							child: Container(
								padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
								child: TextField(
										controller: mainController,
										decoration: InputDecoration(
											border: InputBorder.none
										),
										style: TextStyle(
											color: Colors.grey[350],
											fontSize: 14
										),
										minLines: 30,
										maxLines: 1000,
										cursorColor: Colors.green,
										toolbarOptions: ToolbarOptions(
											copy: true, cut: true, paste: true, selectAll: true,
										),
										onChanged: (text) {
											changeLineNumber(sideBarController.text, text);
                      if(callback != null)
  											callback(text);
										},
									),
							),
						),
					],
				),
			],
		);
	}
}