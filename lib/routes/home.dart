import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:python_text_editor/Widgets/create_room_dialog.dart';
import 'package:python_text_editor/Widgets/main_list_view_item.dart';
import 'package:python_text_editor/Widgets/nav_bar_item.dart';
import 'package:python_text_editor/Widgets/join_room_dialog.dart';
import 'package:python_text_editor/classes/room.dart';
import 'package:python_text_editor/utilities/pusher_api.dart';
import 'package:python_text_editor/utilities/room_api.dart';
import 'package:python_text_editor/utilities/user_auth_api.dart';


class Home extends StatefulWidget {
	@override
	_HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseUser currentUser;
  List<Room> rooms = [];

  void showCreateRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return CreateRoomDialog(
          mainText: '@flutter-app: /my_rooms',
          userName: currentUser.displayName.split(' ')[0].toLowerCase(),
        );
      }
    );
  }

  void showJoinRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return JoinRoomDialog(
          mainText: '@flutter-app: /my_rooms',
          userName: currentUser.displayName.split(' ')[0].toLowerCase(),
        );
      }
    );
  }

  void loadRooms() async {
    // Get current user
    currentUser = await UserAuthApi.getCurrentUser();
    rooms = await RoomApi.getRooms(currentUser.email);
    setState(() {});
  }

  @override
  void initState() {
    loadRooms();
    super.initState();
  }

  void loadRoom(int index) async {
    // Create the old channel
    PusherApi pusherApi = PusherApi();
    await pusherApi.subsribeToChannel(rooms[index].roomKey);
		Navigator.pushNamed(context, '/editor', arguments: {
      'pusherApi' : pusherApi,
      'room': rooms[index],
    });
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Row(
				  children: <Widget>[
				    Expanded(
				      child: Text(
				      	'My Rooms',
				      	style: TextStyle(
				      		color: Colors.white
				      	),
				      ),
				    ),
            IconButton(
              icon: Icon(
                Icons.replay,
                color: Colors.white,
                size: 18,
              ),
              onPressed: (){
                loadRooms();
              },
            )
				  ],
				),
				backgroundColor: Colors.black,
			),
			body: Container(
				child: ListView.builder(
					itemCount: rooms.isEmpty ? 0 : rooms.length,
					itemBuilder: (context, index) {
						return MainListViewItem(
							userName: currentUser.displayName.split(' ')[0].toLowerCase(),
							roomName: rooms[index].roomName,
							roomKey: rooms[index].roomKey,
              callback: () {
                loadRoom(index);
              },
						);
					},
				),
			),
			bottomNavigationBar: BottomAppBar(
				shape: CircularNotchedRectangle(),
				child: Row(
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						NavBarItem(
							icon: Icons.person,
							text: 'Create Room',
              callback: () {
                showCreateRoomDialog(context);
              },
						),
						NavBarItem(
							icon: Icons.list,
							text: 'Join Room',
              callback: () {
                showJoinRoomDialog(context);
              },
						),
					],
				),
			),
		);
	}
}