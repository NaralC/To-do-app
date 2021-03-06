import 'dart:async';
import '../database/todo_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

abstract class DB {
  static Database? _db;
  static int get _version => 1;

  static Future<void> init() async {
    Future<void> onCreate(Database db, int version) async {
      await db.execute(
          'CREATE TABLE TODO (id INTEGER PRIMARY KEY NOT NULL, name STRING)');
    }

    try {
      String _path = await getDatabasesPath();
      String _databasepath = p.join(_path, 'todolist.db');

      _db = await openDatabase(_databasepath,
          version: _version, onCreate: onCreate);
    } catch (exception) {
      print(exception);
    }
  }

  static insert(String table, ToDoItem todo) async {
    return await _db!.insert(table, todo.toMap());
  }

  static query(String table) async {
    return await _db!.query(table);
  }

  static Future<int> delete(String table, ToDoItem todo) async {
    return await _db!.delete(table, where: 'id = ?', whereArgs: [todo.id]);
  }
}
