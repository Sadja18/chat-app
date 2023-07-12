// HTTP request to get all users which matches the given username
import 'dart:developer';

import 'package:flutter/foundation.dart';

Future<List<dynamic>> performUserSearch(String userName) async {
  // Perform your search request to the backend here
  // Replace this with your actual API call or search logic
  await Future.delayed(const Duration(seconds: 2)); // Simulating a delay

  // Return dummy search results
  return List.generate(10, (index) => 'Result $index for "$userName"');
}

Future<dynamic> getPreviousChatMessage(
  String userName,
  int conversationId,
  int limit,
  int offset,
) async {
  try {} catch (e) {
    if (kDebugMode) {
      log("error in fetching previous messages for conversation id ${e.toString()}");
    }
    return null;
  }
}

Future<dynamic> getProfile() async {
  try {} catch (e) {
    if (kDebugMode) {
      log('error in getting profile details of current user');
      log(e.toString());
    }
    return null;
  }
}
