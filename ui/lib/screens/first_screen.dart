import 'package:flutter/material.dart';
import 'package:ui/widgets/login.dart';
import 'package:ui/widgets/register.dart';
// import 'package:flutter/src/widgets/framework.dart';

class FirstScreen extends StatelessWidget {
  static const routeName = '/first-screen';
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Baat Cheet'),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.login_sharp),
                    Text('Existing User'),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_add),
                    Text('New User'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoginWidget(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RegisterWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
