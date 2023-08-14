import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat-screen';

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late int conversationId = 0;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> chatMessages = [];

  // ignore: unused_field
  bool _isLoading = false;
  // ignore: prefer_final_fields
  int _currentPage = 1;
  // ignore: prefer_final_fields
  int _messagesPerPage = 15;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchMessages() {
    // API call to fetch previous messages
    setState(() {
      _isLoading = true;
    });
    if (kDebugMode) {
      log("API call to fetch older messages");
    }

    Future.delayed(const Duration(seconds: 2), () {
      // Fetch the first 15 messages
      final newMessages = _getPreviousMessages();

      // the first item in the result will be the latest message in the 15 messages
      // therefore,
      // get all elements existing chat messages
      var tmp = chatMessages;

      // add the fetched messages to tmp
      tmp = tmp + newMessages;

      // set the chatMessages with tmp;
      setState(() {
        chatMessages = tmp.toList();
      });

      setState(() {
        _isLoading = false;
        _currentPage++;
      });
    });
  }

  List<ChatMessage> _getPreviousMessages() {
    // based on the _currentPage and _messagesPerPage values
    final start = (_currentPage - 1) * _messagesPerPage;
    final end = start + _messagesPerPage;

    return List.generate(end - start, (index) {
      final messageId = index + start;

      if (index % 2 == 0) {
        return ChatMessage(id: messageId, sender: "User1", content: "${messageId.toString()} + $_currentPage");
      } else {
        return ChatMessage(
          id: messageId,
          content: '${messageId.toString()} + $_currentPage',
          sender: 'User',
        );
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Scrolled to the top, fetch previous messages
      if (kDebugMode) {
        log("Scrolled to the top, fetch previous messages");
      }
      _fetchMessages();
    }
  }

  Future<void> _sendMessage(message) async {
    try {
      Future.delayed(const Duration(seconds: 1), () {
        if (kDebugMode) {
          log(message);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        log("error sending $message");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as int;
    conversationId = args;

    return Scaffold(
      appBar: AppBar(
        title: const Text('username'),
        backgroundColor: const Color.fromRGBO(63, 81, 181, 1),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(240, 240, 240, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (!_isLoading && notification is ScrollEndNotification && _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
                    // Scrolled to the top, fetch previous messages
                    if (kDebugMode) {
                      log('scrolled to top, fetch previous messages');
                    }
                    _fetchMessages();
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: chatMessages.length,
                  itemBuilder: (ctx, index) {
                    var chatMessage = chatMessages[index];
                    Alignment alignment = chatMessage.sender == 'User1' ? Alignment.centerLeft : Alignment.centerRight;

                    // User Message background color: Blue Gray
                    // Other User Message background color: Light Silver
                    Color bgColor = chatMessage.sender == 'User1' ? const Color.fromRGBO(207, 216, 220, 1) : const Color.fromRGBO(229, 229, 229, 1);
                    double leftMargin = chatMessage.sender == "User1" ? 5.0 : 40.0;
                    double rightMargin = chatMessage.sender == "User1" ? 40.0 : 5.0;

                    return Container(
                      alignment: alignment,
                      // width: MediaQuery.of(context).size.width*0.70,
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.60,
                        minWidth: MediaQuery.of(context).size.width * 0.10,
                      ),
                      margin: EdgeInsets.only(
                        top: 6.0,
                        bottom: 6.0,
                        left: leftMargin,
                        right: rightMargin,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        chatMessage.content.toString(),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber.shade400,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              alignment: Alignment.bottomLeft,
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  suffixIcon: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.15,
                    alignment: Alignment.bottomRight,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2.0,
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (kDebugMode) {
                          log('new message');
                        }

                        if (_messageController.text != "") {
                          String message = _messageController.text;
                          _sendMessage(message);
                        } else {
                          log('empty click');
                        }
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        color: Colors.lightBlue.shade500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
