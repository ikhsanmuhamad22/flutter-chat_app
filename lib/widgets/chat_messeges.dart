import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMesseges extends StatelessWidget {
  const ChatMesseges({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: false)
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
          itemCount: loadedChat.length,
          itemBuilder: (context, index) =>
              Text(loadedChat[index].data()['text']),
        );
      },
    );
  }
}
