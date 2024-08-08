import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // get instance from firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshots) {
      return snapshots.docs.map((doc) {
        // go through individual user
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }
  // send message

  // get messages
}
