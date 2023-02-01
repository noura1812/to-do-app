import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tablename = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'task.db';
        debugPrint('in data b');
        _db = await openDatabase(
          _path,
          version: _version,
          onCreate: (Database db, int version) async {
            debugPrint('crating data b');

            await db.execute(
                '''CREATE TABLE $_tablename (id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note TEXT, date STRING, startTime STRING, endTime STRING, remind INTEGER, repeat STRING, color INTEGER, isCompleted INTEGER)''');
          },
        );
        debugPrint('db created');
      } catch (e) {
        print('///////////////////////////////ee');
        print(e);
      }
    }
  }

  static Future<int> insert(Task task) async {
    return await _db!.insert(_tablename, task.toJson());
  }

  static Future<int> delet(Task task) async {
    return await _db!.delete(_tablename, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> deletall() async {
    return await _db!.delete(_tablename);
  }

  static Future<List<Map<String, dynamic?>>> query() async {
    return await _db!.query(_tablename);
  }

  static Future<int> update(int id) async {
    return await _db!.rawUpdate(
        'UPDATE $_tablename SET isCompleted = ? WHERE id = ?', [1, id]);
  }
}
