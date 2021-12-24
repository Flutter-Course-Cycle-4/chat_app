//import 'package:chat_app/controllers/rooms_provider.dart';
import 'package:chat_app/models/constants.dart';
import 'package:chat_app/models/room.dart';
//import 'package:chat_app/views/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinRoomScreen extends StatefulWidget {
  static const String routeName = 'join-room';
  const JoinRoomScreen({Key? key}) : super(key: key);

  @override
  _JoinRoomScreenState createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  bool joiningRoom = false;
  /*void joinRoom() async {
    setState(() {
      joiningRoom = true;
    });
    String? error =
        await Provider.of<RoomsProvider>(context, listen: false).joinRoom(room);
    if (error == null) {
      Navigator.of(context)
          .pushReplacementNamed(ChatScreen.routeName, arguments: room);
    } else {
      setState(() {
        joiningRoom = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red[900],
        ),
      );
    }
  }*/

  late Room room;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    room = ModalRoute.of(context)!.settings.arguments as Room;
  }

  @override
  Widget build(BuildContext context) {
    return joiningRoom
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 20),
                  Text('Joining Room...'),
                ],
              ),
            ),
          )
        : Container(
            decoration: Constants.decoration,
            child: Scaffold(
              appBar: AppBar(
                title: Text(room.data.name),
              ),
              body: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Hello, Welcome to our chat room',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Join ${room.data.name}!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.2,
                            ),
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: Constants.getCategoryImage(
                                    room.data.category),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(room.data.description),
                          const SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                primary: const Color(0xFF3598DB),
                              ),
                              onPressed: () {}, //joinRoom,
                              child: const Text('Join'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
