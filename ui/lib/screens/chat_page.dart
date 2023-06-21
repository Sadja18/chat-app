import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat-screen';

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late int conversationId = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as int;
    conversationId = args;
    return Scaffold(
      appBar: AppBar(
        title: const Text('username'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
        ),
        child: Text("ChatArea $conversationId"),
      ),
    );
  }
}
