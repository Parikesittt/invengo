import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';

class StockDropdownModel with CustomDropdownListFilter {
  final String name;
  final IconData icon;
  const StockDropdownModel(this.name, this.icon);

  @override
  String toString() => name;

  @override
  bool filter(String query) => name.toLowerCase().contains(query.toLowerCase());
}
