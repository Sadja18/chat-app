import 'package:flutter/material.dart';
import 'package:ui/screens/first_screen.dart';
import 'package:ui/screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget widgetReturner() {
    return FutureBuilder(builder: (BuildContext ctx, AsyncSnapshot snap) {
      return const SearchScreen();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baat Cheet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => widgetReturner(),
      },
    );
  }
}
