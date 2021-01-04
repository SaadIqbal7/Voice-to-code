import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:python_text_editor/Widgets/create_room_terminal_dialog_text_field.dart';
import 'package:python_text_editor/Widgets/terminal_main_text.dart';
import 'package:python_text_editor/Widgets/terminal_top_bar.dart';
import 'package:python_text_editor/classes/room.dart';
import 'package:python_text_editor/utilities/pusher_api.dart';
import 'package:python_text_editor/utilities/room_api.dart';

class JoinRoomDialog extends StatefulWidget {
  final String mainText;
  final String userName;
  JoinRoomDialog({@required this.mainText, @required this.userName});

  @override
  _JoinRoomDialogState createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  TextEditingController roomKeyController = TextEditingController();
  bool isLoading = false;
  String errorText = '';

  @override
  JoinRoomDialog get widget => super.widget;

  void joinRoom() async {
    setState(() {
      isLoading = true;
    });

    Room room = await RoomApi.getRoom(roomKeyController.text);
    if (room != null) {
      PusherApi pusherApi = PusherApi();
      // Subscribe to channel
      await pusherApi.subsribeToChannel(roomKeyController.text);

      Navigator.pop(context);
      Navigator.pushNamed(context, '/editor', arguments: {
        'pusherApi': pusherApi,
        'room': room,
      });
    } else {
      setState(() {
        errorText =
            'Room does not exist';
      });
      Timer(Duration(seconds: 3), () {
        setState(() {
          errorText = '';
        });
      });
    }
    setState(() {
      isLoading = false;
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
              mainText:
                  widget.userName.split(' ')[0].toLowerCase() + widget.mainText,
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
                        color: Colors.white, fontSize: 11, fontFamily: 'ITC'),
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
                          onPressed: () {
                            joinRoom();
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
                          onPressed: () {
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
                        )
                      : Container(),
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
