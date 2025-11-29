import 'dart:convert';

class TransactionFirebaseModel {
  String? id;
  String itemId;
  int transactionType;
  int total;
  int quantity;
  String? itemName;
  String? date;
  String? createdAt;
  String? updatedAt;

  TransactionFirebaseModel({
    this.id,
    required this.itemId,
    required this.transactionType,
    required this.total,
    required this.quantity,
    this.itemName,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'item_id': itemId,
      'transaction_type': transactionType,
      'total': total,
      'quantity': quantity,
      if (itemName != null) 'item_name': itemName,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (date != null) 'date': date,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }

  factory TransactionFirebaseModel.fromMap(Map<String, dynamic> map) {
    T? read<T>(String camel, String snake) {
      if (map.containsKey(camel) && map[camel] != null) return map[camel] as T;
      if (map.containsKey(snake) && map[snake] != null) return map[snake] as T;
      return null;
    }

    final rawId = read<Object?>('id', 'id');
    final rawItemId = read<Object?>('itemId', 'item_id');
    final rawItemName = read<Object?>('itemName', 'item_name');
    final rawDate = read<Object?>('date', 'date');
    final rawCreatedAt = read<Object?>('createdAt', 'created_at');
    final rawUpdatedAt = read<Object?>('updatedAt', 'updated_at');

    final rawTransactionType = read<Object?>(
      'transactionType',
      'transaction_type',
    );
    final rawTotal = read<Object?>('total', 'total');
    final rawQuantity = read<Object?>('quantity', 'quantity');

    int parseInt(dynamic v, {int fallback = 0}) {
      if (v == null) return fallback;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is num) return v.toInt();
      if (v is String) {
        return int.tryParse(v) ?? fallback;
      }
      return fallback;
    }

    String parseString(dynamic v, {String fallback = ''}) {
      if (v == null) return fallback;
      return v.toString();
    }

    final itemId = parseString(rawItemId, fallback: '');
    if (itemId.isEmpty) {
    }

    final transactionType = parseInt(rawTransactionType, fallback: 0);
    final total = parseInt(rawTotal, fallback: 0);
    final quantity = parseInt(rawQuantity, fallback: 0);

    return TransactionFirebaseModel(
      id: rawId != null ? rawId.toString() : null,
      itemId: itemId,
      transactionType: transactionType,
      total: total,
      quantity: quantity,
      itemName: rawItemName != null ? rawItemName.toString() : null,
      date: rawDate != null ? rawDate.toString() : null,
      createdAt: rawCreatedAt != null ? rawCreatedAt.toString() : null,
      updatedAt: rawUpdatedAt != null ? rawUpdatedAt.toString() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionFirebaseModel.fromJson(String source) =>
      TransactionFirebaseModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
