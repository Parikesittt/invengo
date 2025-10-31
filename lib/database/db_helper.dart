// import 'package:belajar_ppkd/day_19/model/user_model.dart';
import 'package:invengo/model/item_model.dart';
import 'package:invengo/model/user_model.dart';
import 'package:invengo/model/category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBHelper {
  static const tableUser = 'users';
  static const tableCategories = 'categories';
  static const tableItems = 'items';
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'test.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, name TEXT, email TEXT, phone_number TEXT, password TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('''
            DELETE FROM $tableItems WHERE id=1;
          ''');
        }
      },
      version: 6,
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
      print(UserModel.fromMap(results.first));
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

  static Future<void> createCategory(CategoryModel category) async {
    final dbs = await db();
    await dbs.insert(
      tableCategories,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<CategoryModel>> getAllCategory() async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(tableCategories);
    print(results);
    return results.map((e) => CategoryModel.fromMap(e)).toList();
  }

  static Future<void> updateCategory(CategoryModel category) async {
    final dbs = await db();
    await dbs.update(
      tableCategories,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteCategory(int id) async {
    final dbs = await db();
    await dbs.delete(tableCategories, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> createItems(ItemModel item) async {
    final dbs = await db();
    await dbs.insert(
      tableItems,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> getItems(ItemModel item) async {
    final dbs = await db();
    final result = await dbs.rawQuery('''
      SELECT * FROM $tableItems WHERE id
    ''');
  }

  static Future<List<ItemModel>> getAllItems() async {
    final dbs = await db();
    final results = await dbs.rawQuery('''
    SELECT items.*, categories.name AS category_name
    FROM items
    LEFT JOIN categories ON items.category_id = categories.id
  ''');
    print(results);
    return results.map((e) => ItemModel.fromMap(e)).toList();
  }

  static Future<void> updateItems(ItemModel item) async {
    final dbs = await db();
    await dbs.update(
      tableItems,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteItems(int id) async {
    final dbs = await db();
    await dbs.delete(tableItems, where: 'id = ?', whereArgs: [id]);
  }
}
