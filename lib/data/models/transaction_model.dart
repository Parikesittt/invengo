import 'dart:convert';

class TransactionModel {
  int? id;
  int itemId;
  int transactionType;
  int total;
  int quantity;
  String? itemName;

  TransactionModel({
    this.id,
    required this.itemId,
    required this.transactionType,
    required this.total,
    required this.quantity,
    this.itemName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'item_id': itemId,
      'transaction_type': transactionType,
      'total': total,
      'quantity': quantity,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] != null ? map['id'] as int : null,
      itemId: map['item_id'] as int,
      transactionType: map['transaction_type'] as int,
      total: map['total'] as int,
      quantity: map['quantity'] as int,
      itemName: map['item_name'] != null ? map['item_name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
