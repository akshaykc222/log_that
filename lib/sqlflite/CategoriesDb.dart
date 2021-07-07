
import 'package:flutter/material.dart';
import 'package:log_that/Models/CategoriesModel.dart';
import 'package:log_that/Models/DataModel.dart';
import 'package:log_that/Models/SubActivityModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static const String tableNameActivity="Activity";
  static const String tableNameSubActivity="SubActivity";
  static const String tableNameDataModel="dataModel";
  DatabaseHelper._();
  static final DatabaseHelper db= DatabaseHelper._();
     Database? _database;

  Future<Database?> get database async{
    if(_database !=null) return _database;

   _database= await initDB();

    return _database;
  }

  static const tableActivity=  """
           CREATE TABLE IF NOT EXISTS $tableNameActivity (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,dateCreated TEXT NOT NULL,clicked INTEGER  
        ) 
          """;
  static const tableSubActivity="""
           CREATE TABLE IF NOT EXISTS $tableNameSubActivity (
        id INTEGER PRIMARY KEY AUTOINCREMENT,activityId INTEGER,
        title TEXT NOT NULL,dateCreated TEXT NOT NULL,clicked INTEGER,
        FOREIGN KEY (activityId) REFERENCES $tableNameActivity(id) 
        ) 
          """;
  static const tableDataModel="""
           CREATE TABLE IF NOT EXISTS $tableNameDataModel (
        id INTEGER PRIMARY KEY AUTOINCREMENT,subActId INTEGER,
        title TEXT NOT NULL,dataType TEXT NOT NULL,dateCreated TEXT NOT NULL,defValue TEXT,unit TEXT
        FOREIGN KEY (subActId) REFERENCES $tableSubActivity(id) 
        ) 
          """;
  Future<Database> initDB() async{
    print("initDB executed");
    String path = join(await getDatabasesPath(), "LogThat.db");
   // await deleteDatabase(path);
    return await openDatabase(path,
      version: 4,
      onCreate: (Database db,int version) async {
          await db.execute(tableActivity);
          await db.execute(tableSubActivity);
      }
    );
  }
  /* CURD operations for table Activity */
  Future<bool> insertActivity(CategoriesModel model) async {
    final Database? db = await database;
    db!.insert(tableNameActivity, model.toMap());
    return true;
  }

  Future<List<CategoriesModel>> getActivity() async {

    final Database db = await initDB();
    final List<Map<String, dynamic>> datas = await db.rawQuery('SELECT * FROM $tableNameActivity');
    print("item size ${datas.length}");
    return datas.map((e) => CategoriesModel.fromMap(e)).toList();
  }

  Future<int> deleteActivity(int id) async{
    final Database db = await initDB();
   return db.delete(tableNameActivity,where: 'id=?',whereArgs: [id]);

  }
  Future<int> updateActivity(CategoriesModel model) async {
    final Database db = await initDB();
    print(model.toMap());
    return await db.update(tableNameActivity, model.toMap(), where: "id = ?", whereArgs: [model.id]);
  }
/*End CURD operations for table Activity */

/* CURD operations for table SubActivity */
  Future<int> insertSubActivity(SubActivityModel model) async {
    final Database? db = await database;
    return db!.insert(tableNameSubActivity, model.toMap());

  }
  Future<List<SubActivityModel>> getSubActivity(int activityId) async {

    final Database db = await initDB();
    final List<Map<String, dynamic>> datas = await db.rawQuery('SELECT * FROM $tableNameSubActivity WHERE activityId = ?',[activityId]);
    print("item size ${datas.length}");
    return datas.map((e) => SubActivityModel.fromMap(e)).toList();
  }
  Future<int> deleteSubActivity(int id) async{
    final Database db = await initDB();
    return db.delete(tableNameSubActivity,where: 'id=?',whereArgs: [id]);

  }
  Future<int> updateSubActivity(SubActivityModel model) async {
    final Database db = await initDB();
    print(model.toMap());
    return await db.update(tableNameActivity, model.toMap(), where: "id = ?", whereArgs: [model.id]);
  }
/* End CURD operations for table  SubActivity */
/* curd operations for table data model*/

  Future<int> insertDataModel(DataModel model) async {
    final Database? db = await database;
    return db!.insert(tableNameDataModel, model.toMap());

  }
  Future<List<DataModel>> getDataModel(int subActId) async {

    final Database db = await initDB();
    final List<Map<String, dynamic>> datas = await db.rawQuery('SELECT * FROM $tableNameDataModel WHERE subActId = ?',[subActId]);
    print("item size ${datas.length}");
    return datas.map((e) => DataModel.fromMap(e)).toList();
  }
  Future<int> deleteDataModel(int id) async{
    final Database db = await initDB();
    return db.delete(tableNameDataModel,where: 'id=?',whereArgs: [id]);

  }
  Future<int> updateDataModel(SubActivityModel model) async {
    final Database db = await initDB();
    print(model.toMap());
    return await db.update(tableNameActivity, model.toMap(), where: "id = ?", whereArgs: [model.id]);
  }
/*end of operations*/
}
