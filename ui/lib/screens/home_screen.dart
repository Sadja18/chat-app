// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui/models/uri.dart';
import 'package:ui/screens/chat_requests_screen.dart';
import 'package:ui/screens/chat_preview_screen.dart';
import 'package:ui/screens/search_screen.dart';
import 'package:ui/services/api/get.dart';
import 'package:ui/widgets/components/pop_menu_button.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkIfUserEmailIsVerified(),
      builder: (BuildContext ctx, AsyncSnapshot snap) {
        if (snap.connectionState == ConnectionState.active || snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Baat Cheet'),
              centerTitle: false,
            ),
            body: Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(110, 83, 228, 1),
                ),
              ),
            ),
          );
        } else {
          if (kDebugMode) {
            log("in futurebuilder");
            log(snap.data.toString());
          }
          if (snap.data == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Baat Cheet'),
                centerTitle: true,
              ),
              body: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Some error occurred while taking you to home screen.\nPlease contact support for resolution.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            if (snap.data is Map && !snap.data.containsKey('error') && snap.data.containsKey('verification_status')) {
              if (snap.data['verification_status'] == null || (snap.data['verification_status'] is bool && !snap.data['verification_status'])) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Baat Cheet'),
                    centerTitle: true,
                  ),
                  body: Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.70,
                      maxWidth: MediaQuery.of(context).size.width * 0.80,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Verification of Email is required',
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Widget for Email verification with callback method',
                          softWrap: true,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('Baat Cheet'),
                      centerTitle: false,
                      actions: const [
                        PopMenuButton(),
                      ],
                      bottom: TabBar(
                        onTap: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        tabs: [
                          Builder(
                            builder: ((BuildContext ctx) {
                              final isActive = _selectedIndex == 0;
                              return Tab(
                                child: Column(
                                  children: [
                                    const Icon(Icons.chat_bubble_outline_outlined),
                                    if (isActive) const Text('Chats'),
                                  ],
                                ),
                              );
                            }),
                          ),
                          Builder(
                            builder: ((BuildContext context) {
                              final isActive = _selectedIndex == 1;
                              return Tab(
                                child: Column(
                                  children: [
                                    const Icon(Icons.pending_actions_outlined),
                                    if (isActive) const Text('Chat Requests'),
                                  ],
                                ),
                              );
                            }),
                          ),
                          Builder(
                            builder: (BuildContext context) {
                              final isActive = _selectedIndex == 2;
                              return Tab(
                                child: Column(
                                  children: [
                                    const Icon(Icons.person_search_outlined),
                                    if (isActive) const Text('Look Up'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      backgroundColor: const Color.fromRGBO(255, 109, 52, 1),
                    ),
                    body: const TabBarView(
                      children: [
                        ChatsPreviewScreen(),
                        ChatRequestsScreen(),
                        SearchScreen(),
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Baat Cheet'),
                  centerTitle: true,
                ),
                body: Container(
                  alignment: Alignment.center,
                  child: Text(
                    snap.data['error'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
          }
        }
      },
    );
  }
}
