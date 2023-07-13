import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui/screens/chat_requests_screen.dart';
import 'package:ui/screens/chat_preview_screen.dart';
import 'package:ui/screens/search_screen.dart';
import 'package:ui/services/api/get.dart';
import 'package:ui/widgets/components/otp_verification.dart';
import 'package:ui/widgets/components/pop_menu_button.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool showVerificationPage = false;
  void otpVerificationCallBack(String? verified) {
    if (verified.toString().trim() != '') {
      setState(() {
        showVerificationPage = false;
      });

      if (kDebugMode) {
        log("isOtpVerified ${!showVerificationPage}");
      }
    }
  }

  void whichWidget() async {
    var result = await checkIfUserEmailIsVerified();
    if (kDebugMode) {
      log("result loaded");
      // log(result.toString());
      // log("result['verification_status'] == null ${result['verification_status'] == null}");
      // log("result['verification_status'] is bool ${result['verification_status'] is bool}");
      // log(result['verification_status'].toString());
    }
    if (result is Map && !result.containsKey('error') && result.containsKey('verification_status')) {
      if (result['verification_status'] == null || result["verification_status"] is bool) {
        setState(() {
          showVerificationPage = true;
        });
      } else {
        setState(() {
          showVerificationPage = false;
        });
      }
    } else {
      setState(() {
        showVerificationPage = false;
      });
    }
  }

  @override
  void initState() {
    whichWidget();
    if (kDebugMode) {
      log("initstate");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return showVerificationPage
        ? Scaffold(
            appBar: AppBar(
              title: const Text("Baat Cheet"),
              backgroundColor: const Color.fromARGB(255, 184, 116, 27),
              foregroundColor: Colors.white,
            ),
            body: OtpVerificationWidget(
              verificationCallBack: otpVerificationCallBack,
            ),
          )
        : DefaultTabController(
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
}
