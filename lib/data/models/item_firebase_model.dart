import 'dart:convert';

import 'package:dropdown_flutter/custom_dropdown.dart';

class ItemFirebaseModel with CustomDropdownListFilter {
  String? id;
  String categoryId;
  String name;
  int costPrice;
  int sellingPrice;
  int stock;
  String? categoryName;

  ItemFirebaseModel({
    this.id,
    required this.categoryId,
    required this.name,
    required this.costPrice,
    required this.sellingPrice,
    required this.stock,
    this.categoryName,
  });

  @override
  String toString() => name;

  @override
  bool filter(String query) => name.toLowerCase().contains(query.toLowerCase());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category_id': categoryId,
      'category_name': categoryName,
      'name': name,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'stock': stock,
    };
  }

  factory ItemFirebaseModel.fromMap(Map<String, dynamic> map) {
    return ItemFirebaseModel(
      id: map['id'] != null ? map['id'] as String : null,
      categoryId: map['category_id'] as String,
      name: map['name'] as String,
      costPrice: map['cost_price'] as int,
      sellingPrice: map['selling_price'] as int,
      stock: map['stock'] as int,
      categoryName: map['category_name'] != null
          ? map['category_name'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemFirebaseModel.fromJson(String source) =>
      ItemFirebaseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
