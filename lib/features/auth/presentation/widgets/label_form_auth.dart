import 'package:flutter/material.dart';
import 'package:invengo/core/constant/app_text_style.dart';

class LabelAuth extends StatelessWidget {
  final String title;
  const LabelAuth({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyle.cardTitle(context));
  }
}
