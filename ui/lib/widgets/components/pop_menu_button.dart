import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui/screens/first_screen.dart';
import 'package:ui/screens/privacy_settings_screen.dart';
import 'package:ui/services/helper/database_helper.dart';

class PopMenuButton extends StatelessWidget {
  const PopMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return const [
          PopupMenuItem(
            value: 'profile',
            child: Text('Profile'),
          ),
          PopupMenuItem(
            value: 'settings',
            child: Text('Settings'),
          ),
          PopupMenuItem(
            value: 'about',
            child: Text('About'),
          ),
          PopupMenuItem(
            value: 'logout',
            child: Text('Logout'),
          ),
        ];
      },
      onSelected: (selection) {
        switch (selection) {
          case 'profile':
            if (kDebugMode) {
              log('Navigate to profile screen');
            }
            Navigator.of(context).pushNamed(PrivacySettingsScreen.routeName);
            break;

          case 'settings':
            if (kDebugMode) {
              log('Navigate to settings screen');
            }
            break;

          case 'about':
            if (kDebugMode) {
              log('Navigate to About section');
            }
            break;

          case 'logout':
            if (kDebugMode) {
              log('logout user');
              // for dev, delete user with username nama
              // deleteUserFromLocal(false, 'userName', 'nama');
            }
            logout(false, 'naman@example.com').then((value) {
              if (kDebugMode) {
                log(value.toString());
                log("logout occurred in logout");
              }
              Navigator.of(context).pushNamedAndRemoveUntil(FirstScreen.routeName, (route) => false);
            }).catchError((err) {
              if (kDebugMode) {
                log(err.toString());
                log("error occurred in logout");
              }
              Navigator.of(context).pushNamedAndRemoveUntil(FirstScreen.routeName, (route) => false);
            });
            break;

          default:
            if (kDebugMode) {
              log('This navigation to $selection is not implemented yet');
            }
        }
      },
    );
  }
}
