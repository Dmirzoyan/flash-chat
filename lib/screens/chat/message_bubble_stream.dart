import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flutter/material.dart';

class MessageBubbleStream extends StatelessWidget {
  final firestore;
  final myEmail;

  MessageBubbleStream({@required this.firestore, @required this.myEmail});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];

        for (var message in messages) {
          final sender = message.data['sender'];
          final messageBubble = MessageBubble(
            messageText: message.data['text'],
            messageSender: sender,
            isMe: sender == myEmail,
          );
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            children: messageBubbles,
            reverse: true,
          ),
        );
      },
    );
  }
}