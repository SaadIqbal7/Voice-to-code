import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:python_text_editor/Widgets/BottomList.dart';
import 'package:python_text_editor/Widgets/editor.dart';
import 'package:python_text_editor/classes/room.dart';
import 'package:python_text_editor/utilities/errors.dart';
import 'package:python_text_editor/utilities/request.dart';
import 'package:python_text_editor/Widgets/BottomSheet.dart';
import 'package:python_text_editor/utilities/room_api.dart';
import 'package:python_text_editor/utilities/speech_request.dart';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TextEditor extends StatefulWidget {
	@override
	_TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
	TextEditingController mainController = TextEditingController();
	TextEditingController sideBarController = TextEditingController();
	Request request = Request();

	// Variables for speech recognition
	bool _isConfigured = false;
	final SpeechToText speech = SpeechToText();

	final SpeechRequest speechRequest = SpeechRequest();

	void displayOutput(String text) {
		showModalBottomSheet(
			context: context,
			builder: (context) => OutputBottomSheet(text),
		);
	}

	void saveRoomData(Room room) async {
		String msg;
		AuthError error =
				await RoomApi.updateRoomData(room.roomKey, mainController.text);
		if (error.errorCode == 0) {
			msg = 'Document Saved';
		} else {
			msg = error.errorMessage;
		}
		Fluttertoast.showToast(
			msg: msg,
			toastLength: Toast.LENGTH_SHORT,
		);
	}

	Future<void> configureSpeechRecognition() async {
		bool isConfigured = await speech.initialize(
			onError: null, onStatus: null
		);

		if(isConfigured) {
			setState(() {
				_isConfigured = isConfigured;
			});
		} else {
			print('User permission denied');
		}
	}

	void startListening() async {
		if(!_isConfigured) {
			await configureSpeechRecognition();
		}
		
		speech.listen(
			onResult: resultListener,
			listenFor: Duration(seconds: 10),
			cancelOnError: true,
		);
	}

  void writeToEditor(String text) {
    StringBuffer editorBuffer = StringBuffer(
    mainController.text.substring(0, mainController.selection.baseOffset) + text + 
    mainController.text.substring(mainController.selection.baseOffset));
		int position = mainController.selection.baseOffset + text.length;
		mainController.text = editorBuffer.toString();
		mainController.selection = TextSelection.fromPosition(TextPosition(offset: position));
  }

	void resultListener(SpeechRecognitionResult result) {
		Fluttertoast.showToast(
			msg: "${result.recognizedWords}",
			toastLength: Toast.LENGTH_SHORT,
		);
		if(result.finalResult == true) {
			this.speechRequest.sendRequest(result.recognizedWords, writeToEditor);
		}
  }

	@override
	Widget build(BuildContext context) {
		final Map<String, Object> arguments =
				ModalRoute.of(context).settings.arguments;

		Room room = arguments['room'];

		return Scaffold(
			backgroundColor: Colors.grey[850],
			appBar: AppBar(
				title: Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: <Widget>[
						Expanded(
							child: Text(
								'${room.roomName}'
							),
						),
						IconButton(
							icon: Icon(
								Icons.save_alt,
								size: 20,
							),
							color: Colors.grey[400],
							onPressed: () {
								saveRoomData(room);
								request.saveFile(mainController.text);
							},
						),
						IconButton(
							icon: Icon(
								Icons.play_arrow,
								size: 20,
							),
							color: Colors.green[600],
							onPressed: () {
								request.sendRequest(mainController.text, displayOutput);
							},
						),
					],
				),
				backgroundColor: Colors.grey[800],
			),
			body: Stack(
				children: <Widget>[
					Editor(mainController, sideBarController, arguments['pusherApi']),
					BottomToolsList(operation: writeToEditor),
				],
			),
			floatingActionButton: FloatingActionButton(
				mini: true,
				backgroundColor: Colors.yellow,
				child: Icon(
					Icons.mic,
					color: Colors.black,
					size: 23,
				),
				onPressed: () => startListening(),
			),
		);
	}
}
