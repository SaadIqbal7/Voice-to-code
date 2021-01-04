import 'package:flutter/material.dart';
import 'package:python_text_editor/routes/register.dart';
import 'package:python_text_editor/routes/login.dart';
import 'package:python_text_editor/routes/home.dart';
import 'package:python_text_editor/routes/loading_route.dart';
import 'package:python_text_editor/routes/text_editor.dart';


void main() => runApp(MaterialApp(
  initialRoute: '/loading',
  routes: {
    '/register': (context) => Register(),
    '/login': (context) => Login(),
    '/home': (context) => Home(),
    '/loading': (context) => LoadingPage(),
    '/editor': (context) => TextEditor(),
  }
));
