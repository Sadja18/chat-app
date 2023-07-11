import 'package:flutter/material.dart';
import 'package:ui/screens/chat_page.dart';
import 'package:ui/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget widgetReturner() {
    return FutureBuilder(builder: (BuildContext ctx, AsyncSnapshot snap) {
      return const HomeScreen();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baat Cheet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(48, 63, 159, 1),
          titleTextStyle: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color.fromRGBO(240, 240, 240, 1),
          labelStyle: const TextStyle(
            color: Color.fromRGBO(80, 80, 80, 1),
          ),
          hintStyle: const TextStyle(
            color: Color.fromRGBO(160, 160, 160, 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(
                200,
                200,
                200,
                1,
              ), // Foreground color for enabled input borders
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(
                100,
                100,
                100,
                1,
              ), // Foreground color for focused input borders
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(232, 234, 246, 1),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.blue,
          selectionHandleColor: Colors.lightBlue.shade300,
          selectionColor: Colors.orange.shade100,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.15,
              fontSizeDelta: 0.5,
              // fontFamily: 'Poppins',
            ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => widgetReturner(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        // ignore: prefer_const_constructors
        ChatPage.routeName: (context) => ChatPage(),
      },
    );
  }
}
