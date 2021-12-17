import 'dart:math';

import 'package:chat_app/controllers/auth_provider.dart';
import 'package:chat_app/models/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController(),
      password = TextEditingController();

  final GlobalKey<FormState> form = GlobalKey<FormState>();
  bool loggingIn = false, resettingPassword = false;

  void login() async {
    setState(() {
      loggingIn = true;
    });
    String? error =
        await Provider.of<AuthProvider>(context, listen: false).login(
      email.text,
      password.text,
    );

    if (error != null) {
      setState(() {
        loggingIn = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  void resetPassword() async {
    setState(() {
      resettingPassword = true;
    });
    String? error = await Provider.of<AuthProvider>(context, listen: false)
        .resetPassword(email.text);

    setState(() {
      resettingPassword = false;
    });
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reset password email has been sent.'),
        backgroundColor: Colors.green,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return loggingIn || resettingPassword
        ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        : Container(
            decoration: Constants.decoration,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Login'),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value != null &&
                                  value.isNotEmpty &&
                                  EmailValidator.validate(value)) {
                                return null;
                              } else {
                                return "Please enter valid email.";
                              }
                            },
                            controller: email,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              isCollapsed: true,
                              hintText: 'example@abc.com',
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Password',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextFormField(
                            controller: password,
                            obscureText: true,
                            validator: (value) {
                              if (value != null && value.length >= 6) {
                                return null;
                              } else {
                                return "Please enter 6 characters at least.";
                              }
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              isCollapsed: true,
                              hintText: 'enter your password',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        resetPassword();
                      },
                      child: const Text('Forgot Password'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (form.currentState!.validate()) {
                            login();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Login'),
                              Icon(Icons.arrow_right_alt)
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .changeScreen();
                      },
                      child: const Text('Or Create My Account'),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
