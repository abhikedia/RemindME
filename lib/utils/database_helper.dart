import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../model/task.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;

class DatabaseHelper {
  static const dbName = 'tasks3.db';

  static Database _database;

  Future<Database> get db async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    print('path='+path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE TASK (ID INT PRIMARY KEY, DESCRIPTION TEXT NOT NULL, TITLE TEXT NOT NULL, LOCATION TEXT NOT NULL, DONE INT)");
  }

  Future<Tasks> insert(Tasks task) async {
    var dbClient=await db;
    task.id=await dbClient.insert('TASK', task.toMap());
    print("Record Inserted");
  }

  Future<List<Tasks>> getTasks() async {
    print("Get tasks");
    var dbClient = await db;
    List<Map> maps= await dbClient.query('TASK', columns: ['ID','DESCRIPTION', 'TITLE', 'LOCATION', 'DONE']);
    print(maps);
    List<Tasks> tasks=[];
    if(maps.length >0) {
      print("inside");
      for (int i=0;i<maps.length;i++) {
        print(maps[i]);
        tasks.add(Tasks.fromMap(maps[i]));
      }
    }
    //print("Task ka print-");
    //print([0].id);
    return tasks;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
