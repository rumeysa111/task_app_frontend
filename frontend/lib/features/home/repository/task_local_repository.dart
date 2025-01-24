import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_app/models/task_model.dart';

class TaskLocalRepository {
  String tableName = "tasks";
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "task.db");

    return openDatabase(path, version: 4,
        onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        await db.execute(
          'ALTER TABLE $tableName ADD COLUMN isSynced INTEGER NOT NULL',
        );
      }
    }, onCreate: (db, version) {
      return db.execute('''
create table $tableName(
id Text primary key,
title text not null,
description text not null,
uid text not null,
dueAt text not null,
hexColor text not null,
createdAt text not null,
updatedAt text not null,
isSynced integer not null
  

)
''');
    });
  }

  Future<void> instertTask(TaskModel task) async {
    final db = await database;
    await db.insert(tableName, task.toMap());
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db
        .batch(); //Birden fazla veritabanı işlemini topluca yapabilmek için batch kullanılır.
    for (final task in tasks) {
      batch.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true); //: Toplu işlem tamamlanır.
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query(tableName);
    if (result.isNotEmpty) {
      List<TaskModel> tasks = [];
      for (final elem in result) {
        tasks.add(TaskModel.fromMap(elem));
      }
      return tasks;
    }
    return [];
  }

  Future<List<TaskModel>> getUnsycnedTasks() async {
    final db = await database;
    final result =
        await db.query(tableName, where: 'isSynced = ? ', whereArgs: [0]);
    if (result.isNotEmpty) {
      List<TaskModel> tasks = [];
      for (final elem in result) {
        tasks.add(TaskModel.fromMap(elem));
      }
      return tasks;
    }
    return [];
  }

  Future<void> updateRowValue(String id, newValue) async {
    final db = await database;
    await db.update(
      tableName,
      {'isSynced': newValue},
      where: ' id = ? ',
      whereArgs: [id],
    );
 
  }
}
