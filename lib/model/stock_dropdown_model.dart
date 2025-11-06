import 'package:dropdown_flutter/custom_dropdown.dart';

class StockDropdownModel with CustomDropdownListFilter {
  final String name;
  final int id;
  const StockDropdownModel(this.id, this.name);

  @override
  String toString() => name;

  @override
  bool filter(String query) => name.toLowerCase().contains(query.toLowerCase());
}
