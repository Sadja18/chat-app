import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:ui/models/user.dart';
import 'package:ui/services/database/local_storage_db.dart';

Future<dynamic> saveNewUserToDatabase(
    userId, userName, email, authToken) async {
  try {
    User userObject = User.fromMap({
      "userId": userId,
      "userName": userName,
      "email": email,
      "authToken": authToken,
      "loginStatus": 1
    });

    var result = await DataBaseProvider.db.addUser(userObject);

    if (kDebugMode) {
      log("result save user : ");
      log(result.toString());
    }
    return result;
  } catch (e) {
    if (kDebugMode) {
      log("saveUserToDatabase error");
      log(e.toString());
    }
    return null;
  }
}

Future<dynamic> getActiveUser() async {
  try {
    var result = await DataBaseProvider.db.readActiveUser();
    if (kDebugMode) {
      log("result read active user : ");
      log(result.toString());
    }
    return result;
  } catch (e) {
    if (kDebugMode) {
      log('error in getActiveUser');
      log(e.toString());
    }
    return null;
  }
}

Future<dynamic> getUserForEmail(email) async {
  try {
    var result = await DataBaseProvider.db.readUserForEmail(email);
    if (kDebugMode) {
      log('read user for email');
      log(result.toString());
    }
    return result;
  } catch (e) {
    if (kDebugMode) {
      log('error in getUserForEmail');
      log(e.toString());
    }
    return null;
  }
}
