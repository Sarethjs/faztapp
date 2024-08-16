import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  const Message({
    required this.senderEmail,
    required this.senderID,
    required this.receiverID,
    required this.message,
    required this.timestamp,
  });
}
