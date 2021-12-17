import 'package:chat_app/controllers/auth_provider.dart';
import 'package:chat_app/views/screens/authentication/login_screen.dart';
import 'package:chat_app/views/screens/authentication/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final screens = [LoginScreen(), RegisterScreen()];

  @override
  Widget build(BuildContext context) {
    return screens[Provider.of<AuthProvider>(context).currentScreenIndex];
  }
}
