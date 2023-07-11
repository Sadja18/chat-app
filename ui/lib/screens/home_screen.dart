import 'package:flutter/material.dart';
import 'package:ui/screens/chat_requests_screen.dart';
import 'package:ui/screens/chat_preview_screen.dart';
import 'package:ui/screens/search_screen.dart';
import 'package:ui/widgets/components/login.dart';
import 'package:ui/widgets/components/pop_menu_button.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (BuildContext ctx, AsyncSnapshot snapshot) {
      if (isLoggedIn) {
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
      } else {
        return const LoginWidget();
      }
    });
  }
}
