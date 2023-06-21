import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui/screens/chat_page.dart';
import 'package:ui/services/helper/date.dart';

class ChatListItem extends StatelessWidget {
  final int conversationId;
  const ChatListItem({Key? key, required this.conversationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          // ignore: avoid_print
          log("open conversation id $conversationId");
        }
        Navigator.pushNamed(context, ChatPage.routeName,
            arguments: conversationId);
      },
      child: Container(
        width: double.infinity, // Take the entire available width
        margin: const EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: 4.0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.15, // Avatar width
              child: const Text("Avatar"),
            ),
            Expanded(
              flex:
                  3, // Username and conversation id width (0.75 of available width)
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('username'),
                  Text(
                    conversationId.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width *
                  0.2, // Date and time width (0.20 of available width)
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formatDateAndTime(DateTime.now())[0],
                  ),
                  Text(
                    formatDateAndTime(DateTime.now())[1],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
