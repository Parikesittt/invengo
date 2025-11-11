// import 'package:belajar_ppkd/day_19/model/user_model.dart';
import 'package:invengo/model/item_model.dart';
import 'package:invengo/model/transaction_model.dart';
import 'package:invengo/model/user_model.dart';
import 'package:invengo/model/category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const tableUser = 'users';
  static const tableCategories = 'categories';
  static const tableItems = 'items';
  static const tableTransactions = 'transactions';
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'test.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableUser(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            name TEXT,
            email TEXT,
            phone_number TEXT,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE $tableCategories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          INSERT INTO $tableCategories (id, name) VALUES
          (1, 'Makanan'),
          (2, 'Minuman')
        ''');

        await db.execute('''
          CREATE TABLE $tableItems(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            category_id INTEGER,
            stock INTEGER,
            cost_price INTEGER,
            selling_price INTEGER,
            created_at TEXT DEFAULT (datetime('now', 'localtime')),
            updated_at TEXT DEFAULT (datetime('now', 'localtime')),
            FOREIGN KEY (category_id) REFERENCES $tableCategories(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE $tableTransactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item_id INTEGER,
            total INTEGER,
            quantity INTEGER,
            transaction_type INTEGER,
            created_at TEXT DEFAULT (datetime('now', 'localtime')),
            updated_at TEXT DEFAULT (datetime('now', 'localtime')),
            FOREIGN KEY (item_id) REFERENCES $tableItems(id)
          )
        ''');
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

  static Future<UserModel?> getUserById(int id) async {
    final dbs = await db();
    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
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
    final id = await dbs.insert(
      tableItems,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await dbs.insert(tableTransactions, {
      'item_id': id,
      'transaction_type': 0,
      'total': item.costPrice * item.stock,
      'quantity': item.stock,
    });
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

  static Future<Map<String, dynamic>> getItemsTotal() async {
    final dbs = await db();
    final results = await dbs.rawQuery('''
      SELECT 
        COUNT (*) AS total_product,
        SUM(CASE WHEN stock > 0 THEN 1 ELSE 0 END) AS in_stock,
        SUM(CASE WHEN stock < 5 AND stock > 0 THEN 1 ELSE 0 END) AS low_stock,
        SUM(CASE WHEN stock = 0 THEN 1 ELSE 0 END) AS out_of_stock
      FROM items
    ''');

    if (results.isNotEmpty) {
      final row = results.first;
      print(row);
      return {
        'Total Product': row['total_product'],
        'In Stock': row['in_stock'],
        'Low Stock': row['low_stock'],
        'Out of Stock': row['out_of_stock'],
      };
    } else {
      return {'Total Product': 0, 'Low Stock': 0, 'Out of Stock': 0};
    }
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

  static Future<void> createTransaction(
    TransactionModel trans,
    int newPrice,
  ) async {
    final dbs = await db();
    final item = await dbs.query(
      'items',
      where: 'id = ?',
      whereArgs: [trans.itemId],
    );
    if (item.isEmpty) throw Exception('Barang tidak ditemukan');
    int currentStock = item.first['stock'] as int;

    int newStock = currentStock;
    if (trans.transactionType == 0) {
      newStock += trans.quantity;
    } else if (trans.transactionType == 1) {
      if (currentStock < trans.quantity)
        throw Exception('Stok tidak mencukupi');
      newStock -= trans.quantity;
    }

    await dbs.update(
      tableItems,
      {'stock': newStock},
      where: 'id = ?',
      whereArgs: [trans.itemId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await dbs.insert(
      tableTransactions,
      trans.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateTransaction(TransactionModel trans) async {
    final dbs = await db();
    await dbs.update(
      tableTransactions,
      trans.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<TransactionModel>> getAllTransaction() async {
    final dbs = await db();
    final results = await dbs.rawQuery('''
    SELECT $tableTransactions.*, $tableItems.name AS item_name
    FROM $tableTransactions
    LEFT JOIN $tableItems ON $tableTransactions.item_id = $tableItems.id
    ORDER BY id DESC
  ''');
    print(results);
    print(results.map((e) => TransactionModel.fromMap(e)).toList());
    return results.map((e) => TransactionModel.fromMap(e)).toList();
  }

  static Future<Map<String, dynamic>> getTotalTransaction() async {
    final dbs = await db();
    final results = await dbs.rawQuery('''
    SELECT
      SUM(CASE WHEN transaction_type = 0 THEN total ELSE 0 END) AS expenses,
      SUM(CASE WHEN transaction_type = 1 THEN total ELSE 0 END) AS revenue
    FROM transactions
    ''');
    if (results.isNotEmpty) {
      final row = results.first;
      final revenue = (row['revenue'] ?? 0) as num;
      final expenses = (row['expenses'] ?? 0) as num;
      final profit = revenue - expenses;
      print(row);
      return {'revenue': revenue, 'expenses': expenses, 'profit': profit};
    } else {
      return {'revenue': 0, 'expenses': 0, 'profit': 0};
    }
  }
}
