//import 'package:chat_app/controllers/rooms_provider.dart';
import 'package:chat_app/models/constants.dart';
import 'package:chat_app/models/room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRoom extends StatefulWidget {
  static const String routeName = 'new-room';
  const CreateRoom({Key? key}) : super(key: key);

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  GlobalKey<FormState> form = GlobalKey<FormState>();
  TextEditingController name = TextEditingController(),
      description = TextEditingController();
  String? category;
  bool creatingRoom = false;
  /*void submitNewRoom() async {
    if (form.currentState!.validate()) {
      RoomData roomData = RoomData(
        name.text,
        category!,
        description.text,
        [FirebaseAuth.instance.currentUser!.uid],
      );
      setState(() {
        creatingRoom = true;
      });
      String? error = await Provider.of<RoomsProvider>(context, listen: false)
          .createNewRoom(roomData);
      if (error != null) {
        setState(() {
          creatingRoom = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
          backgroundColor: Colors.red[900],
        ));
      } else {
        Navigator.of(context).pop();
      }
    }
  }
*/
  @override
  void dispose() {
    name.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return creatingRoom
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 20),
                  Text('Creating Room...'),
                ],
              ),
            ),
          )
        : Container(
            decoration: Constants.decoration,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Chat App'),
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
                            'Create New Room',
                            style: TextStyle(
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
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/group.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Form(
                            key: form,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: name,
                                  decoration: const InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: 'Room Name',
                                    hintText: 'Enter Room Name',
                                  ),
                                  validator: (value) {
                                    if (value != null && value.length >= 3) {
                                      return null;
                                    }
                                    return 'Room name must consists of at least 3 characters.';
                                  },
                                ),
                                const SizedBox(height: 20),
                                DropdownButtonFormField<String>(
                                    validator: (value) {
                                      if (value != null &&
                                          value != 'Select Room Category') {
                                        return null;
                                      }
                                      return 'Please select room category.';
                                    },
                                    hint: const Text('Select Room Category'),
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      contentPadding: const EdgeInsets.all(10),
                                      border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      prefix: category == null
                                          ? null
                                          : Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              child: ImageIcon(
                                                Constants.getCategoryImage(
                                                    category!),
                                                size: 20,
                                                color: const Color(0xFF3598DB),
                                              ),
                                            ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        child: Text('Movies'),
                                        value: 'Movies',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Music'),
                                        value: 'Music',
                                      ),
                                      DropdownMenuItem(
                                        child: Text('Sports'),
                                        value: 'Sports',
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        category = value;
                                      });
                                    }),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: description,
                                  validator: (value) {
                                    if (value != null && value.length >= 5) {
                                      return null;
                                    }
                                    return 'Room description must consists of at least 5 characters.';
                                  },
                                  maxLines: 3,
                                  minLines: 3,
                                  decoration: const InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: 'Room Description',
                                    hintText: 'Enter Room Description',
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                              onPressed: () {}, //submitNewRoom,
                              child: const Text('Create'),
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
