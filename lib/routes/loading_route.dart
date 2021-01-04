import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:python_text_editor/Widgets/logo.dart';
import 'package:python_text_editor/utilities/pusher_api.dart';
import 'package:python_text_editor/utilities/user_auth_api.dart';


class LoadingPage extends StatefulWidget {
	@override
	_LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
	void checkUserLoggedIn() async {
		FirebaseUser firebaseUser = await UserAuthApi.auth.currentUser();
		if(firebaseUser != null) {
			Navigator.pushReplacementNamed(context, '/home');
		} else {
			Navigator.pushReplacementNamed(context, '/register');
		}
	}

	@override
  void initState() {
    PusherApi pusherApi = PusherApi();
    pusherApi.firePusher();
 		checkUserLoggedIn();
    super.initState();
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			body: Center(
				child: Logo(),
			),
		);
	}
}
