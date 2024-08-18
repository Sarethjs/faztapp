import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faztapp/components/chat_bubble.dart';
import 'package:faztapp/components/message_field.dart';
import 'package:faztapp/services/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.userName,
    required this.receiverID,
  });

  final String receiverID;
  final String userName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Message text controller
  final TextEditingController messageController = TextEditingController();

  // chat & auth service
  final ChatService _chatService = ChatService();

  final FirebaseAuth _authService = FirebaseAuth.instance;

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // cause a delay so that keyboard has time to show up
        // then the amount of remaining space will be calculated
        // then scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    // wait a bit for listview to be built, then scroll to bottom
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    messageController.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // send message
  void sendMessage() async {
    // if there is something inside the textfield
    if (messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(
        widget.receiverID,
        messageController.text,
      );

      // clear textfield
      messageController.clear();

      // scroll down messaages
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.userName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
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
      stream: _chatService.getMessages(senderID, widget.receiverID),
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
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList());
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderID'] == _authService.currentUser!.uid;

    // align message to the right if sender is the current user, otherwise left
    var aligment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: aligment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 16),
      child: Row(
        children: [
          // textfield should take up most of the space
          Expanded(
              child: MessageField(
            controller: messageController,
            hintText: 'Message',
            focusNode: myFocusNode,
          )),
          // send button
          Container(
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
