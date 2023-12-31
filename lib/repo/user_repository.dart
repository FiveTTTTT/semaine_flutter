import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_users');
    var database = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sql = """CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        username TEXT,
        userId TEXT
      );""";
    await database.execute(sql);
  }
  Future<void> deleteDatabase(String path) async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_users');
    await deleteDatabase(path);
  }

  Future<Database> resetDatabase(String path) async {
    await deleteDatabase(path);
    return await setDatabase();
  }
}


class UserRepository {
  late DatabaseConnection _databaseConnection;

  UserRepository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  String table = "users";

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  Future<int?> insertData(Map<String, dynamic> data) async {
    var connection = await database;
    return await connection?.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>?> readData() async {
    var connection = await database;
    return await connection?.query(table);
  }

  Future<List<Map<String, dynamic>>?> readDataById(int userId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id = ?', whereArgs: [userId]);
  }

  Future<int?> updateData(Map<String, dynamic> data) async {
    var connection = await database;
    return await connection?.update(table, data, where: 'userId = ?', whereArgs: [data['userId']]);
  }

  Future<int?> deleteDataById(int userId) async {
    var connection = await database;
    return await connection?.delete(table, where: 'userId = ?', whereArgs: [userId]);
  }
}
