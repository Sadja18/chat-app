import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:ui/services/database/local_storage_db.dart';
import 'package:ui/models/uri.dart';

Future<dynamic> loginUser(String email, String userPassword) async {
  try {
    var requestBody = <String, String>{
      "email": email,
      "password": userPassword,
    };

    var response = await http.post(
      Uri.parse(loginUri),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        log(response.body.toString());
        log('save to db here');
      }

      var data = jsonDecode(response.body);
      if (data != null) {
        if (kDebugMode) {
          log(data.toString());
        }
        var authToken = data['token'];
        var userName = data['name'];

        var result = await DataBaseProvider.db.makeUserActive(userName, authToken);
        return result;
      } else {
        if (kDebugMode) {
          log('response body not work');
          log(response.body.toString());
        }
        return {"status": "failed"};
      }
    } else {
      if (kDebugMode) {
        log('api call failed');
        log(response.statusCode.toString());
        log(response.body.toString());
      }
      return {"status": "failed"};
    }
  } catch (e) {
    if (kDebugMode) {
      log("error in loginUser");
      log(e.toString());
    }
    return null;
  }
}

Future<dynamic> registerUser(String email, String userName, String password, String confirmPassword) async {
  try {
    if (kDebugMode) {
      log("Attempting registerUser for $userName");
    }
    var response = await http.post(
      Uri.parse(registerUri),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{"name": userName, "email": email, "password": password, "confirm_password": confirmPassword}),
    );
    if (kDebugMode) {
      log("registerUser response received");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        log("registerUser decoding json");
      }
      var data = jsonDecode(response.body);
      if (kDebugMode) {
        log("registerUser data decoded");
        log(data.toString());
      }

      if (data["success"] != null &&
          data["success"].toString().trim() == "true" &&
          data['data'] != null &&
          data['data'].toString().trim() != '' &&
          data['data']['token'] != null &&
          data['data']['token'].toString().trim() != '') {
        if (kDebugMode) {
          log("getting token to save in backend");
        }
        var token = data['data']['token'];
        if (kDebugMode) {
          log('attempting db save registerUser');
        }

        // var userMap = LinkedHashMap<String, Object?>.from(user);

        var dbSaveStatus = await DataBaseProvider.db.addUser(<String, Object?>{'userName': userName, 'email': email, 'authToken': token, 'loginStatus': 1});

        if (dbSaveStatus != null && dbSaveStatus.toString().trim() != "") {
          return {"message": "Registration Successful"};
        } else {
          return {"message": "error on storing login credentials"};
        }
      } else {
        return data;
      }
    } else {
      if (kDebugMode) {
        log("error in registerUser");
        log(response.statusCode.toString());
        log(response.body.toString());
      }

      if (response.statusCode == 500) {
        var error = jsonDecode(response.body);
        if (error['message'] != null && error['message'].toString().trim() != "") {
          return error;
        } else {
          return null;
        }
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      log('error in api call registerUser');
      log(e.toString());
    }
    return null;
  }
}

Future<dynamic> logoutUser(bool allUsers) async {
  try {
    if (kDebugMode) {
      log("user logged out");
    }
    var queryForUsers = "SELECT email, authToken FROM User WHERE authToken=?";
    List<dynamic> params = [''];

    if (allUsers) {
      queryForUsers = "$queryForUsers;";
    } else {
      queryForUsers = "$queryForUsers AND loginStatus=?";
      params.add(1);
    }

    var usersResult = await DataBaseProvider.db.dynamicQuery(queryForUsers, params);
    var list = usersResult.toList();

    if (usersResult != null && list.isNotEmpty) {
      for (var item in list) {
        // get authToken
        var authToken = item['authToken'];
        if (kDebugMode) {
          log("logout user with $authToken");
        }
        if (authToken != null && authToken.toString().trim() != "") {
          var response = await http.post(Uri.parse(logoutUri), headers: {'Authorization': 'Bearer $authToken'});

          if (response.statusCode == 200) {
          } else {
            if (kDebugMode) {
              log("error in logout ${response.statusCode}");
            }
          }
        }
        // make api call to backend logout
      }
    } else {
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      log("error in logging out the user");
      log(e.toString());
    }
  }
}
