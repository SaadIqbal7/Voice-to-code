import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:python_text_editor/Widgets/auth_route_bottom_text.dart';
import 'package:python_text_editor/Widgets/code_finish_text.dart';
import 'package:python_text_editor/Widgets/logo.dart';
import 'package:python_text_editor/Widgets/primary_button.dart';
import 'package:python_text_editor/Widgets/register_text_field.dart';
import 'package:python_text_editor/Widgets/sub_logo_text.dart';
import 'package:python_text_editor/utilities/errors.dart';
import 'package:python_text_editor/utilities/user_auth_api.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Register extends StatefulWidget {
	@override
	_RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
	TextEditingController _nameController = TextEditingController();
	TextEditingController _emailController = TextEditingController();
	TextEditingController _passwordController = TextEditingController();
	bool isLoading = false;

	void registerUser() async {
		setState(() {
			isLoading = true;
		});
		AuthError authError = await UserAuthApi.registerUser(
			_emailController.text, _passwordController.text, _nameController.text,
		);
		if (authError.errorCode == 0) {
			// Navigate to home screen
			Navigator.pushReplacementNamed(context, '/home');
		} else {
			// Display error
			Fluttertoast.showToast(
				msg: authError.errorMessage,
				toastLength: Toast.LENGTH_LONG,
			);
			setState(() {
				isLoading = false;
			});
		}
	}

	void navigateToLoginRoute() {
		Navigator.pushNamed(context, '/login');
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			body: Center(
				child: SingleChildScrollView(
					child: Container(
						padding: EdgeInsets.symmetric(horizontal: 30),
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: <Widget>[
								Logo(),
								SizedBox(
									height: 20,
								),
								SubLogoText(
									'Register',
								),
								SizedBox(
									height: 20,
								),
								RegisterTextField(
									controller: _nameController,
									codeBlockText: CodeBlockText(
										text: 'Name',
										fontSize: 13,
										letterSpacing: 1.0,
									),
									keyboardType: TextInputType.text,
									obscureText: false,
								),
								SizedBox(
									height: 10,
								),
								RegisterTextField(
									controller: _emailController,
									codeBlockText: CodeBlockText(
										text: 'E-mail',
										fontSize: 13,
										letterSpacing: 1.0,
									),
									keyboardType: TextInputType.emailAddress,
									obscureText: false,
								),
								SizedBox(
									height: 10,
								),
								RegisterTextField(
									controller: _passwordController,
									codeBlockText: CodeBlockText(
										text: 'Password',
										fontSize: 13,
										letterSpacing: 1.0,
									),
									keyboardType: TextInputType.visiblePassword,
									obscureText: true,
								),
								SizedBox(
									height: 20,
								),
								PrimaryButton(
									text: 'Register',
									callback: registerUser,
								),
								SizedBox(
									height: 20,
								),
								AuthRouteBottomText(
									'Already registered?',
									'Sign in',
									navigateToLoginRoute,
								),
								isLoading ? SpinKitRing(
									color: Colors.red[600],
									size: 40,
									lineWidth: 3,
								):Container()
							],
						),
					),
				),
			),
		);
	}
}
