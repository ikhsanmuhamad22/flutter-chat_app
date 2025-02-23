import 'package:chat_app/widgets/chat_messeges.dart';
import 'package:chat_app/widgets/new_messeges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreens extends StatelessWidget {
  const ChatScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FlutterChat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
      body: Center(
        child: Column(
          children: [Expanded(child: ChatMesseges()), NewMesseges()],
        ),
      ),
    );
  }
}
