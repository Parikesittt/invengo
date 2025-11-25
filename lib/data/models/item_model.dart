// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dropdown_flutter/custom_dropdown.dart';

class ItemModel with CustomDropdownListFilter {
  int? id;
  int categoryId;
  String name;
  int costPrice;
  int sellingPrice;
  int stock;
  String? categoryName;

  ItemModel({
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
      'name': name,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'stock': stock,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] != null ? map['id'] as int : null,
      categoryId: map['category_id'] as int,
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

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
