import 'package:freezed_annotation/freezed_annotation.dart';

part 'items.freezed.dart';
part 'items.g.dart';

@freezed
abstract class ItemModel with _$ItemModel {
  const factory ItemModel({
    required int id,
    required String name,
    required int categoryId,
    required int stock,
    required int costPrice,
    required int sellingPrice,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
}
