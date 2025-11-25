import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invengo/data/models/category_firebase_model.dart';
import 'package:invengo/data/models/item_firebase_model.dart';
import 'package:invengo/data/models/transaction_firebase_model.dart';
import 'package:invengo/data/models/user_firebase_model.dart';
import 'package:invengo/data/models/transaction_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static final _usersCol = _firestore.collection('users');
  static final _categoriesCol = _firestore.collection('categories');
  static final _itemsCol = _firestore.collection('items');
  static final _transactionsCol = _firestore.collection('transactions');

  // ----------------------- USERS -----------------------
  static Future<UserFirebaseModel> registerUser({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    final model = UserFirebaseModel(
      uid: user.uid,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    await _usersCol.doc(user.uid).set(model.toMap());
    return model;
  }

  static Future<UserFirebaseModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) return null;
      final snap = await _usersCol.doc(user.uid).get();
      if (!snap.exists) return null;
      return UserFirebaseModel.fromMap({'uid': user.uid, ...snap.data()!});
    } on FirebaseAuthException catch (e) {
      // normalize common auth errors to null like original sqlite implementation
      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        return null;
      }
      rethrow;
    }
  }

  static Future<void> updateUser(UserFirebaseModel user) async {
    final map = user.toMap();
    map['updatedAt'] = DateTime.now().toIso8601String();
    await _usersCol.doc(user.uid).update(map);
  }

  static Future<List<UserFirebaseModel>> getAllUser() async {
    final snap = await _usersCol.get();
    return snap.docs
        .map((d) => UserFirebaseModel.fromMap({'uid': d.id, ...d.data()}))
        .toList();
  }

  static Future<UserFirebaseModel?> getUserById(String uid) async {
    final snap = await _usersCol.doc(uid).get();
    if (!snap.exists) return null;
    return UserFirebaseModel.fromMap({'uid': snap.id, ...snap.data()!});
  }

  static Future<void> deleteUser(String uid) async {
    await _usersCol.doc(uid).delete();
    // NOTE: You might want to cascade-delete user-related data (if any).
  }

  // ----------------------- CATEGORIES -----------------------
  static Future<void> createCategory(CategoryFirebaseModel category) async {
    // if category.id exists and is intended to be used as doc id, use it.
    if (category.uid != null && category.uid!.isNotEmpty) {
      await _categoriesCol.doc(category.uid).set(category.toMap());
    } else {
      await _categoriesCol.add(category.toMap());
    }
  }

  static Future<List<CategoryFirebaseModel>> getAllCategory() async {
    final snap = await _categoriesCol.get();
    return snap.docs
        .map((d) => CategoryFirebaseModel.fromMap({'uid': d.id, ...d.data()}))
        .toList();
  }

  static Future<void> updateCategory(CategoryFirebaseModel category) async {
    if (category.uid == null) throw Exception('Category uid is required');
    final map = category.toMap();
    await _categoriesCol.doc(category.uid).update(map);
  }

  static Future<void> deleteCategory(String id) async {
    await _categoriesCol.doc(id).delete();
  }

  // ----------------------- ITEMS -----------------------
  static Future<String> createItem(ItemFirebaseModel item) async {
    // build map from model but don't include id/uid
    final map = Map<String, dynamic>.from(
      item.toMap()
        ..remove('id')
        ..remove('uid'),
    );

    // try to inject category_name if categoryId provided
    final categoryId = map['category_id'] as String?;
    if (categoryId != null && categoryId.isNotEmpty) {
      try {
        final catDoc = await _categoriesCol.doc(categoryId).get();
        if (catDoc.exists) {
          final catData = catDoc.data();
          if (catData != null && catData.containsKey('name')) {
            map['category_name'] = catData['name'];
          }
        }
      } catch (e) {
        // log or ignore — we still create the item without category_name
        // print('Failed to resolve category_name: $e');
      }
    }

    map['created_at'] = DateTime.now().toIso8601String();
    map['updated_at'] = DateTime.now().toIso8601String();

    final docRef = await _itemsCol.add(map);

    // create initial transaction to reflect purchase/stock in (transaction_type = 0)
    await _transactionsCol.add({
      'item_id': docRef.id,
      'transaction_type': 0,
      'total': (item.costPrice ?? 0) * (item.stock ?? 0),
      'quantity': item.stock ?? 0,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    return docRef.id;
  }

  static Future<List<ItemFirebaseModel>> getAllItems() async {
    final snap = await _itemsCol.get();
    return snap.docs.map((d) {
      final data = Map<String, dynamic>.from(d.data());
      // inject document id — do NOT rely on stored 'id' field in doc
      data['id'] = d.id;
      // keep any stored category_name (already denormalized if present)
      // fallback: data['category_name'] may be null if older docs exist
      return ItemFirebaseModel.fromMap(data);
    }).toList();
  }

  static Future<void> updateItem(ItemFirebaseModel item) async {
    if (item.id == null || item.id!.isEmpty)
      throw Exception('Item id required');
    final map = Map<String, dynamic>.from(
      item.toMap()
        ..remove('id')
        ..remove('uid'),
    );

    final categoryId = map['category_id'] as String?;
    if (categoryId != null && categoryId.isNotEmpty) {
      try {
        final catDoc = await _categoriesCol.doc(categoryId).get();
        if (catDoc.exists) {
          final catData = catDoc.data();
          if (catData != null && catData.containsKey('name')) {
            map['category_name'] = catData['name'];
          }
        }
      } catch (e) {
        // ignore/log
      }
    }

    map['updated_at'] = DateTime.now().toIso8601String();
    await _itemsCol.doc(item.id).update(map);
  }

  static Future<Map<String, dynamic>> getItemsTotal() async {
    final snap = await _itemsCol.get();
    int totalProduct = snap.docs.length;
    int inStock = 0;
    int lowStock = 0;
    int outOfStock = 0;

    for (final d in snap.docs) {
      final stock = (d.data()['stock'] ?? 0) as num;
      if (stock > 0) inStock++;
      if (stock == 0) outOfStock++;
      if (stock > 0 && stock < 5) lowStock++;
    }

    return {
      'Total Product': totalProduct,
      'In Stock': inStock,
      'Low Stock': lowStock,
      'Out of Stock': outOfStock,
    };
  }

  static Future<ItemFirebaseModel?> getItemById(String id) async {
    final snap = await _itemsCol.doc(id).get();
    if (!snap.exists) return null;
    final data = {'id': snap.id, ...snap.data()!};
    return ItemFirebaseModel.fromMap(data);
  }

  static Future<void> updateItemFields(
    String id,
    Map<String, dynamic> fields,
  ) async {
    if (id.isEmpty) throw Exception('Item id required');
    final map = Map<String, dynamic>.from(fields);
    map.remove('id');
    map.remove('uid');
    // remove null values to avoid overwriting fields with null
    map.removeWhere((key, value) => value == null);
    map['updated_at'] = DateTime.now().toIso8601String();
    await _itemsCol.doc(id).update(map);
  }

  static Future<void> deleteItem(String id) async {
    await _itemsCol.doc(id).delete();
    // note: transactions referencing this item will remain unless you delete them too
  }

  // ----------------------- TRANSACTIONS -----------------------
  /// trans.transactionType: 0 = expense (stock in), 1 = revenue (stock out)
  static Future<void> createTransaction(TransactionFirebaseModel trans) async {
    final itemDocRef = _itemsCol.doc(trans.itemId);

    await _firestore.runTransaction((tx) async {
      final snapshot = await tx.get(itemDocRef);
      if (!snapshot.exists) throw Exception('Item not found');
      final currentStock = (snapshot.data()!['stock'] ?? 0) as int;

      int newStock = currentStock;
      if (trans.transactionType == 0) {
        newStock += trans.quantity;
      } else if (trans.transactionType == 1) {
        if (currentStock < trans.quantity)
          throw Exception('Stok tidak mencukupi');
        newStock -= trans.quantity;
      }

      tx.update(itemDocRef, {
        'stock': newStock,
        'updated_at': DateTime.now().toIso8601String(),
      });

      final map = trans.toMap();
      map['created_at'] = DateTime.now().toIso8601String();
      map['updated_at'] = DateTime.now().toIso8601String();
      // remove id if any, Firestore will set its own
      map.remove('id');
      tx.set(_transactionsCol.doc(), map);
    });
  }

  static Future<void> updateTransaction(TransactionFirebaseModel trans) async {
    if (trans.id == null || trans.id!.isEmpty)
      throw Exception('Transaction id required');
    final map = trans.toMap();
    map['updated_at'] = DateTime.now().toIso8601String();
    await _transactionsCol.doc(trans.id).update(map);
  }

  static Future<List<TransactionFirebaseModel>> getAllTransaction() async {
    final snap = await _transactionsCol
        .orderBy('created_at', descending: true)
        .get();

    // fetch items to map id->name
    final itemsSnap = await _itemsCol.get();
    final Map<String, dynamic> itemsMap = {};
    for (final d in itemsSnap.docs) itemsMap[d.id] = d.data();

    return snap.docs.map((d) {
      final data = {'id': d.id, ...d.data()};
      final itemId = data['item_id'] as String?;
      if (itemId != null && itemsMap.containsKey(itemId)) {
        data['item_name'] = itemsMap[itemId]['name'];
      }
      return TransactionFirebaseModel.fromMap(data);
    }).toList();
  }

  static Future<Map<String, dynamic>> getTotalTransaction() async {
    final snap = await _transactionsCol.get();
    num expenses = 0;
    num revenue = 0;
    for (final d in snap.docs) {
      final data = d.data();
      final type = data['transaction_type'] as int? ?? 0;
      final total = (data['total'] ?? 0) as num;
      if (type == 0) expenses += total; // expense (stock in)
      if (type == 1) revenue += total; // revenue (stock out)
    }

    final profit = revenue - expenses;
    return {'revenue': revenue, 'expenses': expenses, 'profit': profit};
  }
}
