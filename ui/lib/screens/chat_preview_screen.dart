import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatsPreviewScreen extends StatefulWidget {
  static const routeName = '/chats-screen';
  const ChatsPreviewScreen({super.key});

  @override
  State<ChatsPreviewScreen> createState() => _ChatsPreviewScreenState();
}

class _ChatsPreviewScreenState extends State<ChatsPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.70;
    return Container(
      height: maxHeight -
          keyboardHeight -
          kToolbarHeight -
          MediaQuery.of(context).padding.top,
      width: MediaQuery.of(context).size.width * 0.90,
      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
      alignment: Alignment.center,
      child: Column(
        children: const [
          Text('A search bar'),
          Text('Column of chats (retrieve from db)'),
        ],
      ),
    );
  }
}
