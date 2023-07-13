import 'package:flutter/material.dart';
import 'package:ui/widgets/components/chat_list_item.dart';

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
      height: maxHeight - keyboardHeight - kToolbarHeight - MediaQuery.of(context).padding.top,
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
      decoration: const BoxDecoration(
        // color: Colors.amber.shade200,
        color: Color.fromRGBO(102, 153, 102, 1),
      ),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(191, 212, 191, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.96,
            alignment: Alignment.center,
            child: const Text(
              'A search bar',
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            height: MediaQuery.of(context).size.height * 0.70,
            width: MediaQuery.of(context).size.width * 0.98,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.lime.shade100,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  12,
                  (index) => ChatListItem(conversationId: index + 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
