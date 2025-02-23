import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMesseges extends StatefulWidget {
  const NewMesseges({super.key});

  @override
  State<NewMesseges> createState() {
    return _NewMessegesState();
  }
}

class _NewMessegesState extends State<NewMesseges> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onSubmitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'userId': user.uid,
      'username': userData.data()!['name'],
      'createdAt': Timestamp.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 1, bottom: 50, top: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              decoration: InputDecoration(label: Text('Send a messages....')),
            ),
          ),
          IconButton(
            onPressed: _onSubmitMessage,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}
