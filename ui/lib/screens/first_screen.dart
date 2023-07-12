import 'package:flutter/material.dart';
import 'package:ui/widgets/components/login.dart';
import 'package:ui/widgets/components/register.dart';
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
            indicator: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            unselectedLabelStyle: const TextStyle(
              color: Colors.blueGrey,
            ),
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
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: LoginWidget(),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: RegisterWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
