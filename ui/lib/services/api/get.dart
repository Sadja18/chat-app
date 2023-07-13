// HTTP request to get all users which matches the given username
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:ui/models/error_codes.dart';
import 'package:ui/models/uri.dart';
import 'package:ui/services/helper/database_helper.dart';

Future<dynamic> checkIfUserEmailIsVerified() async {
  try {
    if (kDebugMode) {
      log("API call to check if user email is verified");
      log('get auth Token');
    }

    var userObjectsQ = await getActiveUser();

    var userObjectsList = userObjectsQ.toList();

    if (userObjectsList.isNotEmpty) {
      var userObject = userObjectsList[0];
      var token = userObject['authToken'];
      if (kDebugMode) {
        log("token fethced $token");
      }

      if (token.toString().trim() != '') {
        if (kDebugMode) {
          log("sending api request");
        }
        var response = await http.get(Uri.parse(isEmailVerified), headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'});
        if (kDebugMode) {
          log("api response received");
        }

        if (response.statusCode == 200) {
          var body = jsonDecode(response.body);
          if (kDebugMode) {
            log('response body for email verified decoded');
          }
          if (body is Map &&
              body.containsKey('message') &&
              body.containsKey('data') &&
              body['message'].toString().trim() != '' &&
              body['data'] != null &&
              body['data'] is Map &&
              body['data'].containsKey('email_verification_status')) {
            return {'verification_status': body['data']['email_verification_status']};
          } else {
            return {'error': 'Email is not verified.'};
          }
        } else {
          if (response.statusCode == 500) {
            return {'error': errorCodes['HTTP500']};
          } else {
            return {'error': response.statusCode};
          }
        }
      } else {
        return {'error': errorCodes['NO_AUTH']};
      }
    } else {
      return {'error': errorCodes['NO_ACTIVE_USER']};
    }
  } catch (e) {
    if (kDebugMode) {
      log('checkIfUserEmailIsVerified error');
      log(e.toString());
    }
    return null;
  }
}

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
