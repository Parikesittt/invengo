// import 'package:belajar_ppkd/day_19/model/user_model.dart';
import 'package:invengo/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBHelper {
  static const tableUser = 'users';
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'test.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, name TEXT, email TEXT, phone_number TEXT, password TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> createUser(UserModel user) async {
    final dbs = await db();
    await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  static Future<List<UserModel>> getAllUser() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableUser);
    return results.map((e) => UserModel.fromMap(e)).toList();
  }

  static Future<void> updateUser(UserModel user) async {
    final dbs = await db();
    await dbs.update(
      tableUser,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteUser(int id) async {
    final dbs = await db();
    await dbs.delete(tableUser, where: 'id = ?', whereArgs: [id]);
  }
}
