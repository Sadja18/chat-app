import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:ui/services/database/local_storage_db.dart';

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
