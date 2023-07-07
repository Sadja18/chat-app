import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ui/models/uri.dart';
import 'package:ui/services/database/local_storage_db.dart';

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

        var result =
            await DataBaseProvider.db.makeUserActive(userName, authToken);
        return {'status': 'success'};
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
