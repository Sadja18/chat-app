import 'package:flutter/material.dart';

class ChatRequestsScreen extends StatelessWidget {
  static const routeName = '/chat-requests-screen';
  const ChatRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.70;
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
      height: maxHeight -
          keyboardHeight -
          kToolbarHeight -
          MediaQuery.of(context).padding.top,
      width: MediaQuery.of(context).size.width * 0.90,
      child: const Text('A list view of chats.'),
    );
  }
}
