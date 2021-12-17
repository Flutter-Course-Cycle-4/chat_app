import 'package:chat_app/controllers/auth_provider.dart';
import 'package:chat_app/models/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController email = TextEditingController(),
      password = TextEditingController(),
      username = TextEditingController();
  bool isRegistering = false;

  final GlobalKey<FormState> form = GlobalKey<FormState>();

  bool hidePassword = true;

  void createAccount() async {
    setState(() {
      isRegistering = true;
    });
    String? error = await Provider.of<AuthProvider>(context, listen: false)
        .createAccount(email.text, password.text, username.text);
    if (error != null) {
      setState(() {
        isRegistering = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return isRegistering
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
                leading: IconButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false)
                        .changeScreen();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                title: const Text('Create Account'),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    const SizedBox(height: 20),
                    Form(
                      key: form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Username',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value != null && value.trim().length >= 3) {
                                return null;
                              } else {
                                return "Please enter 3 characters at least.";
                              }
                            },
                            controller: username,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              isCollapsed: true,
                              hintText: 'enter a username',
                            ),
                          ),
                          const SizedBox(height: 20),
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
                            validator: (value) {
                              if (value != null && value.trim().length >= 6) {
                                return null;
                              } else {
                                return "Please enter 6 characters at least.";
                              }
                            },
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              suffix: InkWell(
                                onTap: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                child: Icon(
                                  hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(5),
                              isCollapsed: true,
                              hintText: 'enter your password',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (form.currentState!.validate()) {
                            createAccount();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Create Account'),
                              Icon(Icons.arrow_right_alt)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
