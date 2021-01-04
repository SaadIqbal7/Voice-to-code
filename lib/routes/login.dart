import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:python_text_editor/Widgets/auth_route_bottom_text.dart';
import 'package:python_text_editor/Widgets/login_text_field.dart';
import 'package:python_text_editor/Widgets/logo.dart';
import 'package:python_text_editor/Widgets/primary_button.dart';
import 'package:python_text_editor/Widgets/sub_logo_text.dart';
import 'package:python_text_editor/utilities/user_auth_api.dart';
import 'package:python_text_editor/utilities/errors.dart';


class Login extends StatefulWidget {
	@override
	_LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
	TextEditingController _emailController = TextEditingController();
	TextEditingController _passwordController = TextEditingController();
	bool isLoading = false;

	void loginUser() async {
		setState(() {
		  isLoading = true;
		});
		AuthError authError = await UserAuthApi.loginUser(_emailController.text, _passwordController.text);
		if(authError.errorCode == 0) {
			// Pop Login and Register and move to Home
			Navigator.of(context)
				.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false
			);
		} else {
			// Display error
			Fluttertoast.showToast(
				msg: authError.errorMessage,
				toastLength: Toast.LENGTH_LONG,
			);
		}
		setState(() {
		  isLoading = false;
		});
	}

	void navigateToRegisterRoute() {
		Navigator.pop(context);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			body: Container(
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
							'Login',
						),
						SizedBox(
							height: 20,
						),
						LoginTextField(
							controller: _emailController,
							attributeText: 'E-mail',
							keyboardType: TextInputType.emailAddress,
							obscureText: false,
						),
						SizedBox(
							height: 10,
						),
						LoginTextField(
							controller: _passwordController,
							attributeText: 'Password',
							keyboardType: TextInputType.visiblePassword,
							obscureText: true,
						),
						SizedBox(
							height: 20,
						),
						PrimaryButton(
							text: 'Login',
							callback: loginUser,
						),
						SizedBox(
							height: 20,
						),
						AuthRouteBottomText(
							'Do not have an account?',
							'Sign up',
							navigateToRegisterRoute
						),
						isLoading ? SpinKitRing(
							color: Colors.red[600],
							size: 40,
							lineWidth: 3,
						)
						: Container(),
					],
				),
			),
		);
	}
}
