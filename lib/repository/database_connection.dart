// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_todolist_v6');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);

    return database;
  }

  FutureOr<void> _onCreatingDatabase(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE categories (id INTEGER PRIMARY KEY, category TEXT) ''');

    await db.execute(
        '''CREATE TABLE todo (id INTEGER PRIMARY KEY, title TEXT, desciption TEXT,category_id INTEGER, category TEXT, todo_date TEXT, is_finished INTEGER)''');
  }
}
