import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
        ];
      },
      onSelected: (selection) {
        switch (selection) {
          case 'profile':
            if (kDebugMode) {
              log('Navigate to profile screen');
            }
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

          default:
            if (kDebugMode) {
              log('This navigation to $selection is not implemented yet');
            }
        }
      },
    );
  }
}
