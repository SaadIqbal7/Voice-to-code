import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:python_text_editor/classes/room.dart';
import 'package:python_text_editor/utilities/errors.dart';
import 'package:python_text_editor/utilities/user_auth_api.dart';

class RoomApi {
  static Firestore _db = Firestore.instance;

  static Future<Room> createRoom(
      String user, String roomName, String roomKey) async {
    // Get room and see if it already doesn't exist
    Room room = await getRoom(roomKey);
    if (room != null) {
      return null;
    }

    await _db.collection('rooms').document(roomKey).setData({
      'user': user,
      'roomName': roomName,
    });
    return Room(
      roomKey: roomKey,
      user: user,
      roomName: roomName,
    );
  }

  static Future<Room> getRoom(String roomKey) async {
    DocumentSnapshot roomSnapshot =
        await _db.collection('rooms').document(roomKey).get();
    if (!roomSnapshot.exists) {
      return null;
    }

    return Room(
        roomKey: roomSnapshot.documentID,
        roomName: roomSnapshot.data['roomName'],
        user: roomSnapshot.data['user']);
  }

  static Future<AuthError> updateRoomData(String roomKey, String data) async {
    // Check if the change is made by the owner of the document
    // Get room's owner
    Room room = await getRoom(roomKey);
    // Get current user
    FirebaseUser currentUser = await UserAuthApi.getCurrentUser();
    // Check if the change is made by the owner of the document
    if (currentUser.email != room.user) {
      return AuthError(6);
    }

    await _db.collection('rooms').document(roomKey).updateData({'data': data});
    return AuthError(0);
  }

  static Future<List<Room>> getRooms(String user) async {
    QuerySnapshot snapshot = await _db
        .collection('rooms')
        .where('user', isEqualTo: user)
        .getDocuments();
    List<Room> rooms = [];

    snapshot.documents.forEach((doc) {
      rooms.add(Room(
          roomKey: doc.documentID,
          roomName: doc.data['roomName'],
          user: doc.data['user'],
          roomData: doc.data['data']));
    });
		return rooms;
  }
}
