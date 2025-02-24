import 'package:chat_app/widgets/chat_messeges.dart';
import 'package:chat_app/widgets/new_messeges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreens extends StatefulWidget {
  const ChatScreens({super.key});

  @override
  State<ChatScreens> createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

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
