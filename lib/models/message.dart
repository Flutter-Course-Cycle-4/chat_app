import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message, senderName, senderId;
  DateTime sentDate;

  Message({
    required this.message,
    required this.senderName,
    required this.senderId,
    required this.sentDate,
  });

  Message.fromJson(Map<String, Object?> json)
      : this(
          message: json['message']! as String,
          senderName: json['senderName']! as String,
          senderId: json['senderId']! as String,
          sentDate: (json['sentDate']! as Timestamp).toDate(),
        );

  Map<String, Object?> toJson() => {
        'message': message,
        'senderName': senderName,
        'senderId': senderId,
        'sentDate': sentDate,
      };
}
