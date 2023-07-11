import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// import '../../models/user.dart';

class DataBaseProvider {
  DataBaseProvider._();

  static final DataBaseProvider db = DataBaseProvider._();

  static const int version = 1;

  static late Database _database;

  static const dbName = 'baat_cheet.db';

  Future initDB() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(
      path,
      version: version,
      onOpen: (db) {},
      onConfigure: (Database db) async {
        await db.execute("PRAGMA foregin_keys=ON");
      },
      onCreate: (Database db, version) async {
        var dbBatch = db.batch();

        dbBatch.execute(createUserTable());
        dbBatch.execute(createProfileTable());

        await dbBatch.commit(noResult: true);
      },
    );
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  String createUserTable() {
    return "CREATE TABLE User("
        "userName TEXT NOT NULL,"
        "email TEXT NOT NULL,"
        "loginStatus INTEGER DEFAULT 0,"
        "authToken TEXT,"
        "UNIQUE(userName, email)"
        ")";
  }

  String createProfileTable() {
    return "CREATE TABLE Profile("
        "userName TEXT NOT NULL,"
        "avatar TEXT,"
        "firstName TEXT NOT NULL,"
        "lastName TEXT NOT NULL,"
        "contactPhone TEXT NOT NULL,"
        "country TEXT NOT NULL,"
        "onlineStatus TEXT DEFAULT 'false'"
        ")";
  }

  // insert query

  // user
  Future<dynamic> addUser(Map<String, Object?> user) async {
    final db = await initDB();

    var result = await db.insert(
      'User',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (kDebugMode) {
      log('user add res $result');
    }
    return result;
  }

  // update

  // user
  Future<dynamic> makeUserActive(String userName, String authToken) async {
    try {
      final db = await initDB();
      var result = await db.rawInsert(
        "UPDATE User SET loginStatus = ?, authToken = ? WHERE userName=?;",
        [1, authToken, userName],
      );

      return {"status": "success"};
    } catch (e) {
      if (kDebugMode) {
        log("make user active");
        log(e.toString());
      }
      return null;
    }
  }

  // read query

  // read active user
  Future<dynamic> readActiveUser() async {
    try {
      final db = await initDB();
      final res = await db.query(
        'User',
        where: 'loginStatus=?',
        whereArgs: [1],
      );
      return res;
    } catch (e) {
      if (kDebugMode) {
        log('error in readActiveUser');
        log(e.toString());
      }
    }
  }

  // read user for username
  Future<dynamic> readUserForEmail(String email) async {
    try {
      final db = await initDB();
      final res = await db.query(
        'User',
        where: 'email=?',
        whereArgs: [email],
      );
      return res;
    } catch (e) {
      if (kDebugMode) {
        log("error in read user for email");
        log(e.toString());
      }
    }
  }
}
