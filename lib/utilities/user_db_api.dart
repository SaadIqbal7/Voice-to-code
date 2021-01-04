import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:python_text_editor/classes/user.dart';


class UserFirestoreApi {
	static Firestore db = Firestore.instance;

	static Future<User> getUser(String email) async {
		DocumentSnapshot snapshot = await db.collection('users').document(email).get();
		if(!snapshot.exists) {
			return null;
		}
		return User(snapshot.documentID, snapshot.data['name']);
	}

	static Future<void> createUser(String email, String name) async {
		await db.collection('users').document(email).setData({
			'name': name
		});
	}
}
