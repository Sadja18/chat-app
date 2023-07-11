// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform submission logic
      // For example, call an API to authenticate the user
      if (kDebugMode) {
        log('Form submitted');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Baat Cheet"),
      ),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Center(
            child: orientation == Orientation.portrait
                ? buildPortraitLayout()
                : buildLandscapeLayout(),
          );
        },
      ),
    );
  }

  Widget buildPortraitLayout() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLandscapeLayout() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
