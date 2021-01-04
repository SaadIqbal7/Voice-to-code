import 'package:flutter/material.dart';
import 'package:python_text_editor/Widgets/terminal_column.dart';
import 'package:python_text_editor/Widgets/terminal_main_text.dart';
import 'package:python_text_editor/Widgets/terminal_top_bar.dart';


class MainListViewItem extends StatelessWidget {
  final String userName;
  final String roomName;
  final String roomKey;
  final Function callback;

  MainListViewItem(
      {@required this.userName,
      @required this.roomName,
      @required this.roomKey,
      @required this.callback
  });

  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color.fromRGBO(45, 9, 34, 1),
          ),
          child: Column(
            children: <Widget>[
              TerminalTopBar(
                mainText: '$userName@flutter-app: /my_rooms',
                mainTextSize: 11,
                height: 25,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(6, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TerminalMainText(
                      mainText: '$userName@flutter-app',
                      commandText: 'ls -l',
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: <Widget>[
                        ListViewTerminalColumn(
                          heading: 'Permissions',
                          text: '-rwx------',
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ListViewTerminalColumn(
                          heading: 'Room name',
                          text: '$roomName',
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ListViewTerminalColumn(
                          heading: 'Room key',
                          text: '$roomKey',
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
