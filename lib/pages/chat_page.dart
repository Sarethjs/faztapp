import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faztapp/components/my_textfield.dart';
import 'package:faztapp/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    super.key,
    required this.userName,
    required this.receiverID,
  });

  final String receiverID;
  final String userName;

  // Message text controller
  final TextEditingController messageController = TextEditingController();

  // chat & auth service
  final ChatService _chatService = ChatService();
  final FirebaseAuth _authService = FirebaseAuth.instance;

  // send message
  void sendMessage() async {
    // if there is something inside the textfield
    if (messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(
        receiverID,
        messageController.text,
      );

      // clear textfield
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
      ),
      body: Column(
        children: [
          // display all the messages
          Expanded(child: _buildMessageList()),

          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  // build messages list
  Widget _buildMessageList() {
    String senderID = _authService.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderID, receiverID),
      builder: (context, snapshot) {
        // if errors
        if (snapshot.hasError) {
          return const Text('Error loading messages');
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading messages');
        }

        // return list view
        return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList());
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Text(data['message']);
  }

  // build message input
  Widget _buildUserInput() {
    return Row(
      children: [
        // textfield should take up most of the space
        Expanded(
            child: MyTextField(
          controller: messageController,
          hintText: 'Message',
          obscureText: false,
        )),
        // send button
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
      ],
    );
  }
}
