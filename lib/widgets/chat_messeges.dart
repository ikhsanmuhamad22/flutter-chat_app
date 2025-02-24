import 'package:chat_app/widgets/bubble_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMesseges extends StatelessWidget {
  const ChatMesseges({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final userImage = 'https://sl.bing.net/kKTLNFzTLKS';

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No messages found.'),
          );
        }
        final loadedChat = snapshot.data!.docs;

        return ListView.builder(
            padding: EdgeInsets.only(bottom: 30, left: 12, right: 12),
            reverse: true,
            itemCount: loadedChat.length,
            itemBuilder: (context, index) {
              final chatMessage = loadedChat[index].data();
              final nextChatMessage = index + 1 < loadedChat.length
                  ? loadedChat[index + 1].data()
                  : null;

              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  nextChatMessage != null ? nextChatMessage['userId'] : null;
              final nextUserIsSame = nextMessageUserId == currentMessageUserId;

              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageUserId);
              } else {
                return MessageBubble.first(
                    userImage: userImage,
                    username: chatMessage['username'],
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageUserId);
              }
            });
      },
    );
  }
}
