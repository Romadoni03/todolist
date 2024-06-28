import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:todo_list/repository/database_connection.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  static Database? _database;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  Future<Database> get dbTodo async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database!;
    }
  }

  insertData(table, data) async {
    var connection = await dbTodo;
    var result = connection.insert(table, data);
    return result;
  }

  readData(table) async {
    var connection = await dbTodo;
    var result = connection.query(table);
    return result;
  }

  readDataById(table, id) async {
    var connection = await dbTodo;
    var result = await connection.query(table, where: 'id=', whereArgs: [id]);
    return result;
  }

  readDataByIsFinished(table, isFinished) async {
    var connection = await dbTodo;
    var result = await connection
        .query(table, where: 'is_finished=?', whereArgs: [isFinished]);
    return result;
  }

  updateData(table, data) async {
    var connection = await dbTodo;
    var result = await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
    return result;
  }

  deleteData(table, itemid) async {
    var connection = await dbTodo;
    var readData =
        await connection.query(table, where: 'id = ?', whereArgs: [itemid]);
    log(readData.toString());
    var result =
        await connection.rawDelete('DELETE FROM $table WHERE id = $itemid');
    log("deleting");
    return result;
  }

  readTodoByCategory(table, categorytext) async {
    var connection = await dbTodo;
    var result = await connection.query(table,
        where: 'category=?', whereArgs: [categorytext], limit: 1);
    return result;
  }

  updateCategoryTodo(table, category, categorytext) async {
    var connection = await dbTodo;
    var result = await connection.rawUpdate(
        "UPDATE todo SET category = 'mlbb' WHERE category = 'sport'");
    log("cateo" + category);
    log("cattt" + categorytext);
    return result;
  }
}
