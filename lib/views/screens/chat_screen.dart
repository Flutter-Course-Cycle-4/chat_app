import 'dart:io';

import 'package:chat_app/controllers/attatchements_provider.dart';
import 'package:chat_app/controllers/rooms_provider.dart';
import 'package:chat_app/models/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/room.dart';
import 'package:chat_app/views/screens/location_screen.dart';
import 'package:chat_app/views/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String? imagePath;

  void pickImageUsingCamera() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imagePath = image.path;
      });
    }
  }

  void pickImageUsingGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    room = ModalRoute.of(context)!.settings.arguments as Room;
    return WillPopScope(
      onWillPop: () {
        if (Provider.of<AttachmentsProvider>(context, listen: false).showAtt) {
          Provider.of<AttachmentsProvider>(context, listen: false)
              .toggleAttachments();
        }
        return Future.value(true);
      },
      child: leaving
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
          : Material(
              child: InkWell(
                onTap: () {
                  if (Provider.of<AttachmentsProvider>(context, listen: false)
                      .showAtt) {
                    Provider.of<AttachmentsProvider>(context, listen: false)
                        .toggleAttachments();
                  }
                },
                child: Container(
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

                            String? error = await Provider.of<RoomsProvider>(
                                    context,
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
                            const PopupMenuItem(
                                child: Text('Leave'), value: 'leave'),
                          ],
                        )
                      ],
                    ),
                    body: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      margin: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  StreamBuilder<QuerySnapshot<Message>>(
                                      stream: Provider.of<RoomsProvider>(
                                              context,
                                              listen: false)
                                          .getChatRef(room.id)
                                          .orderBy('sentDate', descending: true)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator
                                                .adaptive(),
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
                                              return ChatBubble(
                                                  messages[index]);
                                            },
                                          );
                                        } else {
                                          return const Center(
                                            child: Text('No messages yet'),
                                          );
                                        }
                                      }),
                                  Consumer<AttachmentsProvider>(
                                    builder: (context, attachments, child) {
                                      return AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        height: attachments.showAtt
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1
                                            : 0,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.black87,
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                pickImageUsingCamera();
                                              },
                                              icon: const Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                pickImageUsingGallery();
                                              },
                                              icon: const Icon(
                                                Icons.photo_library,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    LocationScreen.routeName);
                                              },
                                              icon: const Icon(
                                                Icons.location_history,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    height: imagePath == null
                                        ? null
                                        : MediaQuery.of(context).size.height *
                                            0.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                      ),
                                      image: imagePath != null
                                          ? DecorationImage(
                                              image: FileImage(
                                                File(imagePath!),
                                              ),
                                            )
                                          : null,
                                    ),
                                    child: imagePath == null
                                        ? TextField(
                                            controller: message,
                                            minLines: 1,
                                            maxLines: 5,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Type a message...',
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    Provider.of<AttachmentsProvider>(context,
                                            listen: false)
                                        .toggleAttachments();
                                  },
                                  child: const Icon(Icons.attach_file),
                                ),
                                sending
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            sending = true;
                                          });
                                          String msgTxt = message.text;
                                          if (imagePath != null) {
                                            try {
                                              msgTxt = await Provider.of<
                                                          RoomsProvider>(
                                                      context,
                                                      listen: false)
                                                  .uploadImage(
                                                      imagePath!, room.id);
                                            } catch (error) {
                                              setState(() {
                                                sending = false;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                      'Can not add your message please try again later'),
                                                  backgroundColor:
                                                      Colors.red[900],
                                                ),
                                              );
                                              return;
                                            }
                                          }
                                          Message msg = Message(
                                            message: msgTxt,
                                            senderName: FirebaseAuth.instance
                                                .currentUser!.displayName!,
                                            senderId: FirebaseAuth
                                                .instance.currentUser!.uid,
                                            sentDate: DateTime.now(),
                                            type: imagePath != null
                                                ? 'image'
                                                : 'text',
                                          );

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
                                                backgroundColor:
                                                    Colors.red[900],
                                              ),
                                            );
                                          } else {
                                            FocusScope.of(context).unfocus();
                                            imagePath = null;
                                            message.clear();
                                          }
                                        },
                                        icon: const Icon(Icons.send),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
