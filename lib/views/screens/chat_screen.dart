import 'package:chat_app/controllers/rooms_provider.dart';
import 'package:chat_app/models/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/room.dart';
import 'package:chat_app/views/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Room room;
  bool leaving = false, sending = false;
  TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    room = ModalRoute.of(context)!.settings.arguments as Room;
    return leaving
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 20),
                  Text('Leaving Room...'),
                ],
              ),
            ),
          )
        : Container(
            decoration: Constants.decoration,
            child: Scaffold(
              appBar: AppBar(
                title: Text(room.data.name),
                actions: [
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      setState(() {
                        leaving = true;
                      });

                      String? error = await Provider.of<RoomsProvider>(context,
                              listen: false)
                          .leaveRoom(room);
                      if (error == null) {
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          leaving = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error),
                            backgroundColor: Colors.red[900],
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(child: Text('Leave'), value: 'leave'),
                    ],
                  )
                ],
              ),
              body: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                margin:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot<Message>>(
                            stream: Provider.of<RoomsProvider>(context,
                                    listen: false)
                                .getChatRef(room.id)
                                .orderBy('sentDate', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(
                                  child: Text(
                                      'Error has occurred please try again later'),
                                );
                              } else if (snapshot.data!.size > 0) {
                                final messages = snapshot.data!.docs
                                    .map((e) => e.data())
                                    .toList();
                                return ListView.builder(
                                  reverse: true,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    return ChatBubble(messages[index]);
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text('No messages yet'),
                                );
                              }
                            }),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: TextField(
                                controller: message,
                                minLines: 1,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type a message...'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          sending
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : ElevatedButton.icon(
                                  onPressed: () async {
                                    Message msg = Message(
                                      message: message.text,
                                      senderName: FirebaseAuth
                                          .instance.currentUser!.displayName!,
                                      senderId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      sentDate: DateTime.now(),
                                    );
                                    setState(() {
                                      sending = true;
                                    });
                                    String? error =
                                        await Provider.of<RoomsProvider>(
                                                context,
                                                listen: false)
                                            .sendMessage(msg, room.id);
                                    setState(() {
                                      sending = false;
                                    });
                                    if (error != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(error),
                                          backgroundColor: Colors.red[900],
                                        ),
                                      );
                                    } else {
                                      FocusScope.of(context).unfocus();
                                      message.clear();
                                    }
                                  },
                                  icon: const Text('send'),
                                  label: const Icon(Icons.send),
                                ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
