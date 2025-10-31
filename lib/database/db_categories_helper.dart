// import 'package:belajar_ppkd/day_19/model/user_model.dart';
import 'package:invengo/model/category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBCategoryHelper {
  static const tableCategories = 'categories';
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'test.db'),
      onCreate: (db, version) {
        return db.execute('''
            CREATE TABLE $tableCategories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);
            INSERT INTO $tableCategories(id, name) VALUES (1, 'Makanan'), (2, 'Minuman');
          ''');
      },
      version: 1,
    );
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
}
