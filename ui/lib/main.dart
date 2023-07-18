import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui/screens/capture_profile_pic.dart';

import 'package:ui/screens/chat_page.dart';
import 'package:ui/screens/first_screen.dart';
import 'package:ui/screens/home_screen.dart';
import 'package:ui/screens/privacy_settings_screen.dart';
import 'package:ui/services/helper/database_helper.dart';

Color primarySwatchCustomColor = const Color.fromRGBO(51, 153, 255, 1);

MaterialColor customSwatch = MaterialColor(primarySwatchCustomColor.value, {
  50: primarySwatchCustomColor.withOpacity(0.1),
  100: primarySwatchCustomColor.withOpacity(0.2),
  200: primarySwatchCustomColor.withOpacity(0.3),
  300: primarySwatchCustomColor.withOpacity(0.4),
  400: primarySwatchCustomColor.withOpacity(0.5),
  500: primarySwatchCustomColor.withOpacity(0.6),
  600: primarySwatchCustomColor.withOpacity(0.7),
  700: primarySwatchCustomColor.withOpacity(0.8),
  800: primarySwatchCustomColor.withOpacity(0.9),
  900: primarySwatchCustomColor.withOpacity(1.0),
});

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget widgetReturner() {
    return FutureBuilder(
      future: getActiveUser(),
      builder: (BuildContext ctx, AsyncSnapshot snap) {
        if (snap.connectionState == ConnectionState.waiting || snap.connectionState == ConnectionState.active) {
          if (kDebugMode) {
            log("waiting");
          }
          return const SizedBox(child: CircularProgressIndicator.adaptive());
        } else if (snap.data != null &&
            snap.data is List &&
            snap.data.runtimeType.toString() == "List<Map<String, Object?>>" &&
            snap.data.length > 0 &&
            snap.data[0]['loginStatus'] != null &&
            snap.data[0]['loginStatus'] == 1 &&
            snap.data[0]['authToken'] != null &&
            snap.data[0]['authToken'].toString().trim() != '') {
          if (kDebugMode) {
            log('user logged in');
          }
          return const HomeScreen();
        } else {
          if (kDebugMode) {
            log('first screen showing because');
            log("${snap.data.runtimeType}");
            log("${snap.data.length > 0}");
            log(snap.data.toString());
            // log("${snap.data[0]['loginStatus'] != null}");
            // log("${snap.data[0]['loginStatus'] == 1}");
            // log("${snap.data[0]['authToken'] != null}");
            // log("${snap.data[0]['authToken'].toString().trim() != ''}");
          }
          return const FirstScreen();
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baat Cheet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: customSwatch,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(245, 56, 89, 1),
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
        scaffoldBackgroundColor: const Color.fromRGBO(10, 25, 49, 1),
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
        // buttonColor:
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => widgetReturner(),
        FirstScreen.routeName: (context) => const FirstScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        ChatPage.routeName: (context) => const ChatPage(),
        PrivacySettingsScreen.routeName: (context) => const PrivacySettingsScreen(),
        CaptureProfilePicScreen.routeName: (context) => const CaptureProfilePicScreen(),
      },
    );
  }
}
