import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:python_text_editor/Widgets/create_room_terminal_dialog_text_field.dart';
import 'package:python_text_editor/Widgets/terminal_main_text.dart';
import 'package:python_text_editor/Widgets/terminal_top_bar.dart';
import 'package:python_text_editor/classes/room.dart';
import 'package:python_text_editor/utilities/pusher_api.dart';
import 'package:python_text_editor/utilities/room_api.dart';
import 'package:python_text_editor/utilities/user_auth_api.dart';


class CreateRoomDialog extends StatefulWidget {
	final String mainText;
	final String userName;
	CreateRoomDialog({@required this.mainText, @required this.userName});

	@override
	_CreateRoomDialogState createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
	bool isLoading = false;
	TextEditingController roomNameController = TextEditingController();
	TextEditingController roomKeyController = TextEditingController();
  String errorText = '';

	@override
	CreateRoomDialog get widget => super.widget;
	
	void createRoom(BuildContext context) async {
		setState(() {
		  isLoading = true;
		});
		// Get current user
		FirebaseUser currentUser = await UserAuthApi.getCurrentUser();
    // Create room
		Room room = await RoomApi.createRoom(currentUser.email, roomNameController.text, roomKeyController.text);
    if(room == null) {
      setState(() {
        errorText = 'Room already exists';
      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          errorText = '';
        });
      });
      return;
    }

    PusherApi pusherApi = PusherApi();
    // Subscribe to channel
    await pusherApi.subsribeToChannel(roomKeyController.text);
		setState(() {
		  isLoading = false;
		});

		Navigator.pop(context);
		Navigator.pushNamed(context, '/editor', arguments: {
      'pusherApi' : pusherApi,
      'room': room,
    });
	}

	@override
	Widget build(BuildContext context) {
    
		return Dialog(
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
			child: Container(
				color: Color.fromRGBO(45, 9, 34, 1),
				child: Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: <Widget>[
						TerminalTopBar(
							mainText: widget.userName.split(' ')[0].toLowerCase() + widget.mainText,
							mainTextSize: 11,
							height: 25,
						),
						Container(
							padding: EdgeInsets.fromLTRB(6, 8, 0, 8),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
									TerminalMainText(
										mainText: widget.userName + '@flutter-app',
										commandText: 'room -name',
									),
									CreateRoomTerminalDialogTextField(
										child: Icon(
											Icons.keyboard_arrow_right,
											size: 18,
											color: Colors.white,
										),
										controller: roomNameController,
									),
									TerminalMainText(
										mainText: widget.userName + '@flutter-app',
										commandText: 'room -key',
									),
									CreateRoomTerminalDialogTextField(
										child: Icon(
											Icons.keyboard_arrow_right,
											size: 18,
											color: Colors.white,
										),
										controller: roomKeyController,
									),
									Text(
										'Do you want to continue (Y/n)',
										style: TextStyle(
											color: Colors.white,
											fontSize: 11,
											fontFamily: 'ITC'
										),
									),
									Row(
										children: <Widget>[
											ButtonTheme(
												padding: EdgeInsets.all(0),
											  child: FlatButton(
											  	child: Text(
											  		'Y',
											  		style: TextStyle(
															color: Colors.white,
											  			fontFamily: 'ITC',
											  			fontSize: 13,
											  		),
											  	),
											  	onPressed: (){
														createRoom(context);
													},
											  ),
											),
											ButtonTheme(
												padding: EdgeInsets.all(0),
											  child: FlatButton(
											  	child: Text(
											  		'n',
											  		style: TextStyle(
											  			color: Colors.white,
											  			fontFamily: 'ITC',
											  			fontSize: 13,
											  		),
											  	),
											  	onPressed: (){
														Navigator.pop(context);
													},
											  ),
											),
										],
									),
									SizedBox(
										height: 10,
									),
									isLoading 
									? SpinKitThreeBounce(
										size: 11,
										color: Colors.white,
									) : Container(),
                  Container(
                    child: Text(
                      '$errorText',
                      style: TextStyle(
                        color: Colors.red[500],
                        fontFamily: 'ITC',
                        fontSize: 12,
                      ),
                    ),
                  ),
								],
							),
						)
					],
				),
			),
		);
	}
}
