import 'package:chat_app/controllers/auth_provider.dart';
import 'package:chat_app/views/screens/authentication/auth_screen.dart';
import 'package:chat_app/views/screens/authentication/login_screen.dart';
import 'package:chat_app/views/screens/authentication/register_screen.dart';
import 'package:chat_app/views/screens/chat_screen.dart';
import 'package:chat_app/views/screens/create_room.dart';
import 'package:chat_app/views/screens/home_screen.dart';
import 'package:chat_app/views/screens/join_room_screen.dart';
import 'package:chat_app/views/screens/location_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/attatchements_provider.dart';
import 'controllers/rooms_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => RoomsProvider()),
      ChangeNotifierProvider(create: (context) => AttachmentsProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      routes: {
        CreateRoom.routeName: (context) => const CreateRoom(),
        JoinRoomScreen.routeName: (context) => const JoinRoomScreen(),
        ChatScreen.routeName: (context) => ChatScreen(),
        LocationScreen.routeName: (context) => LocationScreen(),
      },
      home: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }
            if (snapshot.data != null) {
              return HomeScreen();
            } else {
              return AuthScreen();
            }
          }),
    );
  }
}
