// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => _ItemModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  categoryId: (json['categoryId'] as num).toInt(),
  stock: (json['stock'] as num).toInt(),
  costPrice: (json['costPrice'] as num).toInt(),
  sellingPrice: (json['sellingPrice'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ItemModelToJson(_ItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categoryId': instance.categoryId,
      'stock': instance.stock,
      'costPrice': instance.costPrice,
      'sellingPrice': instance.sellingPrice,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
