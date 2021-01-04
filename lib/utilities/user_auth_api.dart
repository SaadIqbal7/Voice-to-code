import 'package:firebase_auth/firebase_auth.dart';
import 'package:python_text_editor/classes/user.dart';
import 'package:python_text_editor/utilities/errors.dart';
import 'package:python_text_editor/utilities/user_db_api.dart';

class UserAuthApi {
	static FirebaseAuth auth = FirebaseAuth.instance;

	// Returns error message and error status
	static Future<AuthError> registerUser(String email, String password, String name) async {
		// Check if email, password or name are not empty
		if(name.isEmpty) {
			return AuthError(4);
		} else if(email.isEmpty) {
			return AuthError(1);
		} else if(password.isEmpty) {
			return AuthError(2);
		}
		// If the user already exists
		User user = await UserFirestoreApi.getUser(email);
		if(user != null) {
			return AuthError(3);			
		}

		// Register user
		AuthResult authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
		// Create UserUpdateInfo object to update the user's informaition
		UserUpdateInfo userInfo = UserUpdateInfo();
		userInfo.displayName = name;
		// Update user's name
		await authResult.user.updateProfile(userInfo);
		// Add user to firestore
		await UserFirestoreApi.createUser(email, name);
		// No errors
		return AuthError(0);
	}

	static Future<AuthError> loginUser(String email, String password) async {
		if(email.isEmpty) {
		return AuthError(1);
		} else if(password.isEmpty) {
			return AuthError(2);
		}

		// Get user tp check if the user exists or not
		User user = await UserFirestoreApi.getUser(email);
		if(user == null) {
			return AuthError(5);
		}

		// Login user
		await auth.signInWithEmailAndPassword(email: email, password: password);
		// Indicates no error
		return AuthError(0);
	}

  static Future<FirebaseUser> getCurrentUser() async {
    return await auth.currentUser();
  }
}
