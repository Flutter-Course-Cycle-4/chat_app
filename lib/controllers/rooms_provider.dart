import 'dart:io';

import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RoomsProvider with ChangeNotifier {
  final roomsRef =
      FirebaseFirestore.instance.collection('rooms').withConverter<Room>(
    fromFirestore: (snapshot, options) {
      return Room.fromJson(snapshot.data()!);
    },
    toFirestore: (room, options) {
      return room.toJson();
    },
  );

  CollectionReference<Message> getChatRef(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('chat')
        .withConverter<Message>(
      fromFirestore: (snapshot, options) {
        return Message.fromJson(snapshot.data()!);
      },
      toFirestore: (message, options) {
        return message.toJson();
      },
    );
  }

  Future<String?> createNewRoom(RoomData roomData) async {
    try {
      final roomDoc = roomsRef.doc();
      Room room = Room(roomDoc.id, roomData);
      await roomsRef.doc(room.id).set(room);
      return null;
    } catch (error) {
      print(error);
      return 'Error has occurred please try again later';
    }
  }

  bool joinedTheRoom(Room room) {
    String id = FirebaseAuth.instance.currentUser!.uid;
    return room.data.users.contains(id);
  }

  Future<String?> joinRoom(Room room) async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    try {
      room.data.users.add(id);
      await roomsRef.doc(room.id).set(room);
      return null;
    } catch (error) {
      print(error);
      room.data.users.remove(id);
      return 'Error has occurred please try again later';
    }
  }

  Future<String?> leaveRoom(Room room) async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    try {
      room.data.users.remove(id);
      await roomsRef.doc(room.id).set(room);
      return null;
    } catch (error) {
      print(error);
      room.data.users.add(id);
      return 'Error has occurred please try again later';
    }
  }

  Future<String?> sendMessage(Message message, String roomId) async {
    try {
      final chatRef = getChatRef(roomId);
      await chatRef.add(message);
      return null;
    } catch (error) {
      print(error);
      return 'Error has occurred please try again later';
    }
  }

  Future<String> uploadImage(String path, String roomId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final imageRef =
        FirebaseStorage.instance.ref('$roomId/$userId${DateTime.now()}');
    final image = await imageRef.putFile(File(path));
    return image.ref.getDownloadURL();
  }
}
