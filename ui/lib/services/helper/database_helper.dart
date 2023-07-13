import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:ui/services/database/local_storage_db.dart';

/// The function `getActiveUser` retrieves the active user from a database and returns it as a list, or
/// an empty list if no active user is found.
///
/// Returns:
///   The function `getActiveUser` returns a `Future<dynamic>`.
Future<dynamic> getActiveUser() async {
  try {
    var result = await DataBaseProvider.db.readActiveUser();
    if (kDebugMode) {
      log("result read active user : ");
      log(result.toString());
      log(result.runtimeType.toString());
      // log(result.length)
    }
    if (result != null && result.isNotEmpty) {
      var resultList = result.toList();
      return resultList;
    } else {
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      log('error in getActiveUser');
      log(e.toString());
    }
    return null;
  }
}

/// The function `getUserForEmail` retrieves a user from the database based on their email address and
/// returns the result, or null if there is an error.
///
/// Args:
///   email: The `email` parameter is a string that represents the email address of the user you want to
/// retrieve from the database.
///
/// Returns:
///   a `Future<dynamic>`.
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

/// The function `logout` logs out a user by updating their login status and authentication token in the
/// database.
///
/// Args:
///   allActive (bool): A boolean value indicating whether to logout all active users or just the user
/// with the specified email.
///   email (String): The email parameter is a string that represents the email of the user who wants to
/// logout.
///
/// Returns:
///   a `Future<dynamic>`.
Future<dynamic> logout(bool allActive, String email) async {
  try {
    if (kDebugMode) {
      log("logout active user");
    }
    var query = "UPDATE User SET loginStatus=?, authToken=?";

    if (allActive) {
      query = "$query ;";
      var params = [0, "''"];
      var result = await DataBaseProvider.db.dynamicQuery(query, params);
      return result;
    } else {
      query = "$query WHERE email=?;";
      var params = [0, "''", email];
      var result = await DataBaseProvider.db.dynamicQuery(query, params);
      return result;
    }
  } catch (e) {
    if (kDebugMode) {
      log("error in logoutUser");
      log(e.toString());
    }
    return null;
  }
}

/// The function `deleteUserFromLocal` deletes a user from the local database based on the provided
/// field name and value, and optionally deletes all users if the `all` parameter is set to true.
///
/// Args:
///   all (bool): A boolean value indicating whether to delete all users or just a specific user.
///   fieldName (String): The `fieldName` parameter is a string that represents the name of the field in
/// the User table that you want to use for filtering the deletion. For example, if you want to delete a
/// user with a specific username, you would pass "username" as the `fieldName` parameter.
///   fieldVal (String): The `fieldVal` parameter is the value of the field that you want to match when
/// deleting a user from the local database. For example, if you want to delete a user with the email
/// "example@example.com", you would pass "example@example.com" as the `fieldVal` parameter.
///
/// Returns:
///   a Future<dynamic>.
Future<dynamic> deleteUserFromLocal(bool all, String fieldName, String fieldVal) async {
  try {
    if (kDebugMode) {
      log("deleting user $fieldName $fieldVal");
    }

    var query = "DELETE FROM User";

    if (all) {
      query = "$query;";
      var result = await DataBaseProvider.db.dynamicQuery(query, []);
      return result;
    } else {
      query = "$query WHERE $fieldName='$fieldVal';";
      var result = await DataBaseProvider.db.dynamicQuery(query, []);
      return result;
    }
  } catch (e) {
    if (kDebugMode) {
      log("error in logoutUser");
      log(e.toString());
    }
    return null;
  }
}

Future<dynamic> getUserDetailsForProfileScreen() async {
  try {
    if (kDebugMode) {
      log("getting user name and email for profile page");
    }
    var query = "SELECT userName, email FROM User WHERE loginStatus=1;";
    var resultQ = await DataBaseProvider.db.dynamicQuery(query, []);
    if (kDebugMode) {
      log("resultQ profile screen fetched");
      log(resultQ.toString());
    }

    var resultList = resultQ.toList();
    if (kDebugMode) {
      log(resultList.toString());
    }

    if (resultList.isNotEmpty) {
      return resultList;
    } else {
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      log("error in gettings profile details for current user");
      log(e.toString());
    }
    return null;
  }
}

Future<dynamic> updateFieldInTable(String tableName, String fieldName, dynamic fieldVal) async {
  try {
    if (kDebugMode) {
      log('updating');
      log("table: $tableName, field: $fieldName, val: $fieldVal");
    }
    var query = "UPDATE $tableName SET $fieldName=?;";
    var params = [fieldVal];
    var result = await DataBaseProvider.db.dynamicQuery(query, params);
    return result;
  } catch (e) {
    if (kDebugMode) {
      log('error in updatedFieldInTable');
      log(e.toString());
    }
    return null;
  }
}
