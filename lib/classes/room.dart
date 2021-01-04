import 'package:flutter/cupertino.dart';

class Room {
  String roomKey;
  String roomName;
  String user;
  String roomData;

  Room({
    @required this.roomKey,
    @required this.user,
    @required this.roomName,
    this.roomData = ''
  });
}
