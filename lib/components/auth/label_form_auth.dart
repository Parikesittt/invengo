import 'package:flutter/material.dart';

class LabelAuth extends StatelessWidget {
  final String title;
  const LabelAuth({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontWeight: FontWeight.bold),);
  }
}