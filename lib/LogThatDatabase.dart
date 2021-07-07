import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:path/path.dart';

class DB{

  Future<Database> initDB() async{
    String path=await getDatabasesPath();
    return openDatabase(
      join(path,"logThat.db"),
      version: 1,
      onCreate: (database,version) async{
        await database.execute(
          """
          CREATE TABLE C
          """
        );
      }
    );
  }
}

